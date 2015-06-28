<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:easylist="urn:http://easylist.com.au/api"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml easylist scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
    
<xsl:output method="xml" omit-xml-declaration="yes"/>
    
    <!--
    !! NOTE: After editing this file you will need to re-save all EasyList XSLT's !!
    -->

    
<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="scripts">
<msxml:assembly name="System.Web"/>
<msxml:assembly name="System.Web.Services"/>
<msxml:assembly name="System.Xml.Linq"/>
<msxml:assembly name="EasyList.WebServicesClient" />
<msxml:assembly name="Componax.ExtensionMethods" />
<msxml:assembly name="NLog" />
<msxml:using namespace="System.Web"/>
<msxml:using namespace="System.Xml"/>
<msxml:using namespace="System.Collections.Generic"/>
<msxml:using namespace="System.Xml.Linq"/>
<msxml:using namespace="System.Xml.XPath"/>
<msxml:using namespace="System.Net"/>
<msxml:using namespace="System.Web.Caching"/>
<msxml:using namespace="EasyList.WebServicesClient"/>
<msxml:using namespace="Componax.ExtensionMethods"/>
<msxml:using namespace="System.IO" />  
<msxml:using namespace="NLog" />  
<![CDATA[

        static Logger log = LogManager.GetCurrentClassLogger();

        public string GetImageUrl(string s, int width, int height)
        {
            return s.Replace("640x480", string.Format("{0}x{1}", width, height));
        }

        /// <summary>
        /// Logs in an EasyList user
        /// </summary>
        public XPathNodeIterator LogonUser(string userName, string password)
        {
            return ApiHelper.LogonUser(userName, password);
        }

        /// <summary>
        /// Sets the session variables for logged-in users
        /// </summary>

	  //public void SetUserSessionVars(string userName, string password, string displayName, string userCode)
	  //{
	  //    Session["easylist-username"] = userName;
	  //    Session["easylist-password"] = password;
	  //    Session["easylist-displayname"] = displayName;
	  //    Session["easylist-usercode"] = userCode;
	  //}

	  public void ClearSessionInfoVars()
	  {
		  Session["SessionInfo"] = "";

			
	  }
		
	  public void SetUserSessionVars(string userName, string displayName, string userCode, string userSignature, string UserSignatureDT)
	  {
		  if (!string.IsNullOrEmpty(userName)) userName = userName.Trim();
		  if (!string.IsNullOrEmpty(userCode)) userCode = userCode.Trim();

		  Session["easylist-username"] = userName;
		  Session["easylist-password"] = "";
		  Session["easylist-displayname"] = displayName;
		  Session["easylist-usercode"] = userCode;
		  Session["easylist-userSignature"] = userSignature;
		  Session["easylist-userSignatureDT"] = UserSignatureDT;
			
		  Session["easylist-SupportUsername"] = "";
		  Session["easylist-IsUWSupport"] = "";
		  Session["easylist-usergrouplist"] = "";
		  Session["easylist-IsRetailUser"] = "";

 		  //log.Info("Session timeout 1 min");
		  // Session.Timeout = 1; 
	  }

        /// <summary>
        /// Gets a session variable
        /// </summary>
        public string GetSessionVar(string key)
        {
            return Session[key] == null ? null : Session[key].ToString();
        }

        public string FormatPrice(string s)
        {
            if (string.IsNullOrEmpty(s))
                return string.Empty;
            var price = decimal.Parse(s);
            return price == 0 ? "" : price.ToString("###,###,###.00");
        }

        /// <summary>
        /// Redirects the user to the specified URL
        /// </summary>
        public void RedirectTo(string url)
        {
            Response.Redirect(url);
        }

			public XPathNodeIterator GetAllCategories(string userName, string password)
			{
				return ApiHelper.GetAllCategories(userName, password);
			}

		public static XPathNodeIterator GetNewestListings(string userName, string password, int count)
		{
			return ApiHelper.GetNewestListings(userName, password, count);
		}

		public static XPathNodeIterator SearchListings(string userName, string password, int page)
        {
			return ApiHelper.SearchListings(userName, password, page, 20,
                 0,  0, null,
                 null,  null,  null,  true,  false,
                 false);
		}

		public static XPathNodeIterator SearchListings(string userName, string password, int page, int pageSize,
                decimal minPrice, decimal maxPrice, string[] condition,
                string[] keywords, string category, string sortOrder, bool includeSold, bool includeArchived,
                bool searchDescriptions)
        {
			return ApiHelper.SearchListings(userName, password, page, pageSize,
                 minPrice,  maxPrice, condition,
                 keywords,  category,  sortOrder,  includeSold,  includeArchived,
                 searchDescriptions);
		}


        /// <summary>
        /// Gets the edit data for a listing
        /// </summary>
        public XPathNodeIterator GetListingEditData(string userName, string password, string listingCode)
        {
            return ApiHelper.GetListingEditData(userName, password, listingCode);
        }

        /// <summary>
        /// Updates a listing
        /// </summary>
        public XPathNodeIterator UpdateListing()
        {
            try
            {
                var listingType = GetString("listing-type");
                switch (listingType)
                {
                    case "auto":
                        log.Debug("Updating an auto listing...");
                        return UpdateAutomotiveListing();

                    case "motorcycle":
                        log.Debug("Updating a motorcycle listing...");
                        return UpdateMotorcycleListing();

                    default:
                        log.Debug("Updating a gm listing...");
                        return UpdateGMListing();
                }
            }
            catch (Exception ex)
            {
                log.Error("Error updating listing: " + ex);
                return null;
            }
        }

        /// <summary>
        /// Updates a General Merchandise listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator UpdateGMListing()
        {
            return ApiHelper.UpdateListing(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("listing-title"),
                GetString("listing-summary"),
                GetString("listing-description"),
                GetPrice("listing-price"),
                GetPrice("listing-was-price"),
                GetString("listing-price-qualifier"),
                GetString("listing-condition"),
                GetBool("lock-title"),
                GetBool("lock-summary-description"),
                GetBool("lock-title"),
                GetBool("lock-price"),
                GetBool("lock-was-price"),
                GetBool("lock-price-qualifier"),
                GetBool("lock-condition"),
                !GetBool("listing-publish")
                );
        }

        /// <summary>
        /// Updates a Motorcycle listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator UpdateMotorcycleListing()
        {
            log.Debug("user: " + Session["easylist-username"]);
            log.Debug("pass: " + Session["easylist-password"]);

            var response = ApiHelper.UpdateMotorcycleListing(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("listing-title"),
                GetString("listing-summary"),
                GetString("listing-description"),
                GetPrice("listing-price"),
                GetPrice("listing-was-price"),
                GetString("listing-price-qualifier"),
                GetString("listing-condition"),
                GetString("listing-transmission"),
                GetString("listing-exterior-colour"),
                GetString("listing-gears"),
                GetString("listing-engine"),
                GetString("listing-cylinders"),
                GetBool("lock-title"),
                GetBool("lock-summary-description"),
                GetBool("lock-description"),
                GetBool("lock-price"),
                GetBool("lock-was-price"),
                GetBool("lock-price-qualifier"),
                GetBool("lock-condition"),
                GetBool("lock-transmission"),
                GetBool("lock-exterior-colour"),
                GetBool("lock-gears"),
                GetBool("lock-engine"),
                GetBool("lock-cylinders"),
                !GetBool("listing-publish")
                );

            log.Debug("Update MC Response: " + response.ToPropertiesString());
            return response;
        }

        /// <summary>
        /// Updates and anutomotive listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator UpdateAutomotiveListing()
        {
            return ApiHelper.UpdateAutoListing(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("listing-title"),
                GetString("listing-summary"),
                GetString("listing-description"),
                GetPrice("listing-price"),
                GetPrice("listing-was-price"),
                GetString("listing-price-qualifier"),
                GetString("listing-condition"),
                GetString("listing-body-style"),
                GetInt("listing-doors"),
                GetInt("listing-seats"),
                GetString("listing-body-style-description"),
                GetString("listing-exterior-colour"),
                GetString("listing-interior-colour"),
                GetInt("listing-odometer-value"),
                GetString("listing-odometer-unit"),
                GetString("listing-registration-number"),
                GetString("listing-registration-type"),
                GetString("listing-drive-type"),
                GetString("listing-transmission-description"),
                GetString("listing-engine-type-description"),
                GetString("listing-engine-cylinders"),
                GetString("listing-engine-size-description"),
                GetString("listing-fuel-type-description"),
                GetString("listing-transmission-type"),
                GetBool("lock-title"),
                GetBool("lock-summary-description"),
                GetBool("lock-description"),
                GetBool("lock-price"),
                GetBool("lock-was-price"),
                GetBool("lock-price-qualifier"),
                GetBool("lock-condition"),
                GetBool("lock-body-style"),
                GetBool("lock-doors"),
                GetBool("lock-seats"),
                GetBool("lock-body-style-description"),
                GetBool("lock-exterior-colour"),
                GetBool("lock-interior-colour"),
                GetBool("lock-odometer"),
                GetBool("lock-registration"),
                GetBool("lock-drive-type"),
                GetBool("lock-transmission-description"),
                GetBool("lock-engine-type-description"),
                GetBool("lock-engine-cylinders"),
                GetBool("lock-engine-size-description"),
                GetBool("lock-fuel-type-description"),
                GetBool("lock-transmission-type"),
                !GetBool("listing-publish")
                );
        }

        /// <summary>
        /// Modifies the images for a listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator ModifyListingImages()
        {
            return ApiHelper.ModifyListingImages(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("photo-order"),
                GetString("photo-captions"),
                GetString("delete-photos")
                );
        }

        /// <summary>
        /// Modifies the videos for a listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator ModifyListingVideos()
        {
            return ApiHelper.ModifyListingVideos(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("video-order"),
                GetString("video-captions"),
                GetString("video-descriptions"),
                GetString("delete-videos")
                );
        }

        /// <summary>
        /// Modifies the features for an automotive listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator ModifyAutoFeatures()
        {
            return ApiHelper.ModifyAutoFeatures(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("listing-standard-features"),
                GetString("listing-optional-features")
                );
        }

        /// <summary>
        /// Adds a YouTube video to a listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator AddListingVideo()
        {
            return ApiHelper.InsertListingVideo(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetString("insert-video-title"),
                GetString("insert-video-description"),
                "YouTube",
                GetString("insert-video")
                );
        }

        /// <summary>
        /// Deletes a video from a listing
        /// </summary>
        /// <returns></returns>
        public XPathNodeIterator DeleteListingVideo()
        {
            return ApiHelper.DeleteListingVideo(
                Session["easylist-username"].ToString(),
                Session["easylist-password"].ToString(),
                GetString("listing-code"),
                GetLong("video-id")
                );
        }
/*
public string GetSearchPageUrl(string pageNum, string minPrice,
    string maxPrice, string condition, string category, string keywords, string sort)
  {

      return string.Format("/listings?price-min={0}&price-max={1}&condition={2}&q={3}&sort={4}&page={5}&cat={6}",
        minPrice, maxPrice, condition, keywords, sort, pageNum, category);

  }
*/

public string UrlEncode(string s)
  {
    if(string.IsNullOrEmpty(s)) return s;
    return s.Replace(" ","+");
  }

  public string UrlDecode(string s)
  {
    if(string.IsNullOrEmpty(s)) return s;
    return s.Replace("+"," ");
  }


        #region HTTP Form Helpers

        internal HttpContext Context
        {
            get { return HttpContext.Current; }
        }

        internal HttpResponse Response
        {
            get { return HttpContext.Current.Response; }
        }

        internal HttpRequest Request
        {
            get { return HttpContext.Current.Request; }
        }

        internal System.Web.SessionState.HttpSessionState Session
        {
            get { return HttpContext.Current.Session; }
        }

        internal string GetString(string name)
        {
            return Request.Form[name];
        }

        internal decimal? GetPrice(string name)
        {
            var value = Request.Form[name];
            if (string.IsNullOrEmpty(value)) return (decimal?)null;
            try
            {
                return decimal.Parse(value.Replace("$", "").Replace(",", ""));
            }
            catch
            {
                return (decimal?)null;
            }
        }

        internal int? GetInt(string name)
        {
            var value = Request.Form[name];
            if (string.IsNullOrEmpty(value)) return (int?)null;
            try
            {
                return int.Parse(value.Replace("$", "").Replace(",", ""));
            }
            catch
            {
                return (int?)null;
            }
        }

        internal long GetLong(string name)
        {
            var value = Request.Form[name];
            if (string.IsNullOrEmpty(value)) return 0;
            try
            {
                return long.Parse(value);
            }
            catch
            {
                return 0;
            }
        }

        internal bool GetBool(string name)
        {
            var value = Request.Form[name];
            if (string.IsNullOrEmpty(value)) return false;
            return value == "true";
        }

        #endregion

]]>
</msxml:script>

</xsl:stylesheet>