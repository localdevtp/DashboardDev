<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
    
<xsl:output method="xml" omit-xml-declaration="yes"/>
    
    <!--
    !! NOTE: After editing this file you will need to re-save all EasyList XSLT's !!
    -->

    
<!-- C# helper scripts -->
<msxml:script language="C#" implements-prefix="scripts">
<msxml:assembly name="System.Web"/>
<msxml:assembly name="System.Xml.Linq"/>
<msxml:using namespace="System.Web"/>
<msxml:using namespace="System.Xml"/>
<msxml:using namespace="System.Xml.Linq"/>
<msxml:using namespace="System.Net"/>
<msxml:using namespace="System.Web.Caching"/>
  <msxml:using namespace="System.Globalization" />
  <msxml:using namespace="System.Threading" />
  
<![CDATA[

public string ToTitleCase(string str)
{
CultureInfo cultureInfo   = Thread.CurrentThread.CurrentCulture;
TextInfo textInfo = cultureInfo.TextInfo;
return textInfo.ToTitleCase(str.ToLower());
}


  public string GetYouTubeVideoLink(string id, string width, string height)
  {
    string vars = "hd=1";
    return string.Format("<iframe width=\"{2}\" height=\"{3}\" src=\"http://www.youtube-nocookie.com/embed/{0}?{1}\"></iframe>",
        id, vars, width, height);
  }

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

  public string GetLocationsDataUrl(string dealerID)
  {
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=locations&dealer={0}", dealerID);
  }

  public string GetDealerInfoUrl(string dealerID, string includeVariants, string includeBodyStyles, string forceConditions)
  {
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=dealerinfo&dealer={0}&variants={1}&bodystyles={2}&condition={3}",
      dealerID,
      includeVariants=="1" ? "true" : "false",
      includeBodyStyles=="1" ? "true" : "false",
      forceConditions == "None" ? null : forceConditions);
  }

  public string GetAllItemsUrl(string dealerID)
  {
      // http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=all&dealer=27Z8Q49Q
      return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=all&dealer={0}", dealerID);
  }
  public string GetMakesModelsUrl(string dealerID, string listingID, string type, string forceConditions)
  {
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=makesmodels&dealer={0}&listing={1}&type={2}&condition={3}",
      dealerID, listingID, type,
      forceConditions == "None" ? null : forceConditions);
  }

  public string GetCategoriesUrl(string dealerID, string startPath, string forceCondition)
  {
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=categories&dealer={0}&start={1}&condition={2}",
      dealerID, startPath, forceCondition);
  }

  public string GetYearOptions(int startYear, string reverse)
  {
      if(startYear == 0) startYear = 1990;
      string options = "";
      if(reverse == "true")
      {
        for(int i = startYear; i <= DateTime.Now.Year; i++)
        {
          options += string.Format("<option value=\"{0}\">{0}</option>", i);
        }
      }
      else
      {
        for(int i = DateTime.Now.Year; i >= startYear; i--)
        {
          options += string.Format("<option value=\"{0}\">{0}</option>", i);
        }
      }
      return options;
  }

  public string GetPoweredByString(string mode)
  {
     if(HttpRuntime.Cache["easylist-poweredby"] != null) return HttpRuntime.Cache["easylist-poweredby"].ToString();
     var web = new WebClient();
     var s = web.DownloadString("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=poweredby&type="+ mode);
     HttpRuntime.Cache.Add("easylist-poweredby", s, null, DateTime.Now.AddHours(1), TimeSpan.Zero, CacheItemPriority.High, null);
     return s;
  }

  public string GetGMSearchUrl(string dealerID, int page, int pageSize, string minPrice,
    string maxPrice, string condition, string category,
    string photos, string searchKeywords, string sortOrder, string location)
  {
//    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=search&type=all&dealer={0}&page={1}&items={2}&min={3}&max={4}&condition={5}&cat={6}&photos={7}&q={8}&sort={9}&location={10}",
//     dealerID, page, pageSize, minPrice, maxPrice, condition, category,
//     photos, searchKeywords, sortOrder, location);

//    return string.Format("http://api.mongodbv1.dev.easylist.com.au/APIv2/easylist.aspx?action=search&type=all&dealer={0}&page={1}&items={2}&min={3}&max={4}&condition={5}&cat={6}&photos={7}&q={8}&sort={9}&location={10}&getall=1",
//     dealerID, page, pageSize, minPrice, maxPrice, condition, category,
//     photos, searchKeywords, sortOrder, location);

    return string.Format("http://api.mongodbv1.dev.easylist.com.au/APIv2/easylist.aspx?action=search&type=gm&dealer={0}&page={1}&items={2}&min={3}&max={4}&condition={5}&cat={6}&photos={7}&q={8}&sort={9}&location={10}&getall=1",
     dealerID, page, pageSize, minPrice, maxPrice, condition, category,
     photos, searchKeywords, sortOrder, location);
  }

  public string GetCarSearchUrl(string dealerID, int page, int pageSize, string make,
    string model, string variant, string minYear, string maxYear, string minPrice,
    string maxPrice, string minKM, string maxKM, string transmission, string condition,
    string photos, string searchKeywords, string sortOrder, string location, string GetAllListing, string StockNumber)
  {
//	return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=search&type=car&dealer={0}&page={1}&items={2}&make={3}&model={4}&variant={5}&minyear={6}&maxyear={7}&min={8}&max={9}&minkm={10}&maxkm={11}&transmission={12}&condition={13}&photos={14}&q={15}&sort={16}&location={17}",
//      dealerID, page, pageSize, make, model, variant, minYear, maxYear, minPrice,
//      maxPrice, minKM, maxKM, transmission, condition, photos, searchKeywords, sortOrder, location);

 	return string.Format("http://api.mongodbv1.dev.easylist.com.au/APIv2/easylist.aspx?action=search&type=car&dealer={0}&page={1}&items={2}&make={3}&model={4}&variant={5}&minyear={6}&maxyear={7}&min={8}&max={9}&minkm={10}&maxkm={11}&transmission={12}&condition={13}&photos={14}&q={15}&sort={16}&location={17}&getall={18}&StockNumber={19}",
      dealerID, page, pageSize, make, model, variant, minYear, maxYear, minPrice,
      maxPrice, minKM, maxKM, transmission, condition, photos, searchKeywords, sortOrder, location, GetAllListing, StockNumber);

  }


  public string GetMotorcycleSearchUrl(string dealerID, int page, int pageSize, string make,
    string model, string minYear, string maxYear, string minPrice,
    string maxPrice, string condition,
    string photos, string searchKeywords, string sortOrder, string location)
  {
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=search&type=motorcycle&dealer={0}&page={1}&items={2}&make={3}&model={4}&minyear={5}&maxyear={6}&min={7}&max={8}&condition={9}&photos={10}&q={11}&sort={12}&location={13}",
      dealerID, page, pageSize, make, model, minYear, maxYear, minPrice,
      maxPrice, condition, photos, searchKeywords, sortOrder, location);
  }

  public string GetProductUrl(string category, string make, string model, string title, string code)
  {

return string.Format("/listings/view?listing={0}", code);

/*
    switch(category)
    {
        case "Automotive/Cars/Cars For Sale":
          return string.Format("/cars-for-sale/{0}/{1}/{2}/{3}/",
            FixUrlString(make), FixUrlString(model), FixUrlString(title), code);
        break;

        case "Automotive/Motorbikes":
        case "Automotive/Motorbikes/Motorbikes For Sale":
          return string.Format("/motorbikes-for-sale/{0}/{1}/{2}/{3}/",
            FixUrlString(make), FixUrlString(model), FixUrlString(title), code);
        break;

        default:
          return string.Format("/for-sale/{0}/{1}/{2}/",
            FixCategoryString(category), FixUrlString(title), code);
          break;
	}*/
  }

  public string FixCategoryString(string s)
  {
      if(!s.Contains("/")) return FixUrlString(s);
      int lastSlash = s.LastIndexOf("/") + 1;
      return FixUrlString(s.Substring(lastSlash));
  }

  public string FixUrlString(string s)
  {
      return s.Replace("/", "-").Replace(" ", "-").Replace(",","");
  }

  public string FormatPrice(string s)
  {
      if(string.IsNullOrEmpty(s))
        return string.Empty;
      var price = decimal.Parse(s);
      return price == 0 ? "" : price.ToString("C");
  }

  public string DecimalToInt(string s)
  {
    if(string.IsNullOrEmpty(s))
          return string.Empty;
        var price = decimal.Parse(s);
        return price == 0 ? "" : price.ToString("#");
  }

  public string FormatPrice(string price, string qualifier, string prefix){
    if(string.IsNullOrEmpty(price))
      return string.Empty;
    var p = decimal.Parse(price);
    if(p == 0)
      return string.Empty;
    return string.Format("{0}{1}{2}",
      prefix,
      p.ToString("C"),
      string.IsNullOrEmpty(qualifier) ? string.Empty : " "+ qualifier );
  }

  public string GetSearchBreadcrumbs(string searchType, string category, string make,
    string model, string variant, string gmTitle, string carsTitle, string motorbikesTitle)
  {
    StringBuilder sb = new StringBuilder("<li>");
    if(searchType == "gm")
    {
        sb.AppendFormat("<a href=\"/for-sale\">{0}</a></li>", gmTitle);
        if(!string.IsNullOrEmpty(category))
        {
            sb.AppendFormat("<li class=\"breadcrumb-separator\"></li><li><a href=\"/for-sale/{0}\">{0}</a></li>", category);
        }
        sb.Append("<li class=\"breadcrumb-separator\"></li>");
    }
    else if(searchType == "cars")
    {
        sb.AppendFormat("<a href=\"/cars-for-sale\">{0}</a></li>", carsTitle);
        if(!string.IsNullOrEmpty(make))
        {
            sb.AppendFormat("<li class=\"breadcrumb-separator\"></li><li><a href=\"/cars-for-sale/{0}\">{0}</a></li>", make);
            if(!string.IsNullOrEmpty(model))
            {
                sb.AppendFormat("<li class=\"breadcrumb-separator\"></li><li><a href=\"/cars-for-sale/{0}/{1}\">{1}</a></li>", make, model);
            }
        }
        sb.Append("<li class=\"breadcrumb-separator\"></li>");
    }
    else if(searchType == "motorbikes")
    {
        sb.AppendFormat("<a href=\"/motorbikes-for-sale\">{0}</a></li>", motorbikesTitle);
        if(!string.IsNullOrEmpty(make))
        {
            sb.AppendFormat("<li class=\"breadcrumb-separator\"></li><li><a href=\"/motorbikes-for-sale/{0}\"> {0}</a></li>", make);
            if(!string.IsNullOrEmpty(model))
            {
                sb.AppendFormat("<li class=\"breadcrumb-separator\"></li><li><a href=\"/motorbikes-for-sale/{0}/{1}\">{1}</a></li>", make, model);
            }
        }
        sb.Append("<li class=\"breadcrumb-separator\"></li>");
    }

    return sb.ToString();
     
  }

  /// <summary>
  /// Truncates a string to the specified length, ensuring the break happens on a word boundary
  /// </summary>
  public static string TruncateAtWord(string input, int length)
  {
      if (input == null || input.Length < length)
          return input;
      int iNextSpace = input.LastIndexOf(" ", length);
      return string.Format("{0}...", input.Substring(0, (iNextSpace > 0) ? iNextSpace : length).Trim());
  }

  public string GetNewestItemsDataUrl(string dealerID, int items, string photos, string forceConditions){
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=newitems&dealer={0}&items={1}&photos={2}&condition={3}",
      dealerID, items, photos == "1" ? "only" : null,
      forceConditions == "None" ? null : forceConditions);
  }

  public string GetItemDataUrl(string dealerID, string adNumber, int relatedItems){
 //return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=get&dealer={0}&listing={1}&items={2}",
 //   dealerID, adNumber, relatedItems);
	return string.Format("http://api.mongodbv1.dev.easylist.com.au/APIv2/easylist.aspx?action=get&dealer={0}&listing={1}&items={2}",
      dealerID, adNumber, relatedItems);
  }

/*
  public string GetAnyItemDataUrl(string adNumber){
    return string.Format("http://api.sng.easylist.com.au/apiv2/easylist.aspx?action=getany&listing={0}",
       adNumber);
  }
*/

  public string GetImageUrl(string s, int width, int height){
    return s.Replace("640x480", string.Format("{0}x{1}", width, height));
  }

  public string Trim(string s, int chars){
    if(string.IsNullOrEmpty(s) || s.Length < chars)
      return s;
    return s.Substring(0, chars) + "...";
  }

  public string TrimTitle(string s){
    if(string.IsNullOrEmpty(s) || s.Length < 60)
      return s;
    return s.Substring(0, 60) + "...";
  }

  public string GetSearchPageUrl(string dealerID, string type, string pageNum, string make,
    string model, string variant, string minYear, string maxYear, string minPrice,
    string maxPrice, string minKM, string maxKM, string transmission, string condition,
    string photos, string category, string keywords, string sort, string location)
  {

      return string.Format("/listings?make={0}&model={1}&variant={2}&transmission={3}&price-min={4}&price-max={5}&year-min={6}&year-max={7}&condition={8}&q={9}&sort={10}&type={12}&page={11}&dealer={13}&location={14}&cat={15}",
         make, model, variant, transmission, minPrice, maxPrice, minYear, maxYear,
        condition, keywords, sort, pageNum, type, dealerID, location, category);

  }
  
  public string RemoveSlashes(string s)
  {
    if(string.IsNullOrEmpty(s)) return s;
    return s.Replace("/","-").Replace("\\","-").Replace(",", "").Replace(" ","-");
  }

  public void RedirectTo(string url)
  {
      //HttpContext.Current.Response.Redirect(url);
        //HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Status = "301 Moved Permanently";
        HttpContext.Current.Response.AddHeader("Location", url);
        //HttpContext.Current.Response.End();
  }

  public void RedirectToHome()
  {
      HttpContext.Current.Response.Redirect("/");
  }

  public string CleanQueryStringValue(string val)
  {
    if(string.IsNullOrEmpty(val)) return "";
    return val.Replace(" years","").Replace(" year","").Replace("$","").Replace("%","").Replace(" Months","").Replace(" months","");
  }

public string CalculateWeeklyPrice(string price, string rate, string term, string down)
{
    if(string.IsNullOrEmpty(price)) return "ask us";

    try{
    double amt = double.Parse(price);

    if(amt < 100) return "ask us";

    double downp = double.Parse(down);
    amt = amt - downp;

    if(amt < 0) return "---";

    double yrs = double.Parse(term)*12;
    double rte = double.Parse(rate)/1200;
    double pmt = (rte+(rte/(Math.Pow((1+rte),(yrs))-1)))*amt;
    pmt = pmt*100;pmt=Math.Round(pmt);
    pmt=pmt/100;
    pmt=pmt*12/52;    
    return pmt.ToString("###,###");
    }
    catch { return "ask us"; }
}

public string GetFinanceQueryString(string rate, string down, string repayment, string term, string balloon)
{
    var qs = System.Web.HttpUtility.ParseQueryString(string.Empty);
    if(!string.IsNullOrEmpty(rate)) qs["fr"] = rate;
    if(!string.IsNullOrEmpty(down)) qs["fd"] = down;
    if(!string.IsNullOrEmpty(repayment)) qs["fp"] = repayment;
    if(!string.IsNullOrEmpty(term)) qs["ft"] = term;
    if(!string.IsNullOrEmpty(balloon)) qs["fb"] = balloon;
    var s = qs.ToString();
    return s == "&" ? "" : s;
}

public string FormatDescription(string s, int sentences)
{
   s = s.Replace("'","&apos;")
    .Replace("\"","&quot;")
    .Replace("¿", "&apos;")
    .Replace(".,", ".")
    .Replace("``", "&quot;")
    .Replace("`", "&apos;");

   StringBuilder sb = new StringBuilder("<p itemprop=\"description\">");
   string[] parts = s.Split(new string[]{". "}, StringSplitOptions.RemoveEmptyEntries);
   int count = 0;
   foreach(string part in parts)
   {
      count++;
      sb.Append(part.Trim() +". ");
      if(count == sentences)
      {
        count = 0;
        sb.Append("<br/><br/>");
      }
   }
    sb.Append("</p>");
    return sb.ToString();
}


public string FormatAutoGenEnquiryMessage(string template, string title)
{
    return template.Replace("$item-title", title);
}

public string FormatAutoGenContent(string template, string make, string model, string year,
string category, string categoryPath, string condition, string title, string price)
{
  if(string.IsNullOrEmpty(template)) return title;

  return template.Replace("$make", make)
    .Replace("$model", model)
    .Replace("$year", year)
    .Replace("$categorypath", categoryPath)
    .Replace("$category", category)
    
    .Replace("$condition", condition)
    .Replace("$title", title)
    .Replace("$price", FormatPrice(price));
}

public string Set404Response()
{
  try{
  if(HttpContext.Current != null && HttpContext.Current.Response != null)
  {
    HttpContext.Current.Response.TrySkipIisCustomErrors = true;
    HttpContext.Current.Response.StatusCode = 404;
    HttpContext.Current.Response.StatusDescription = "404 - Sorry, this item has been sold or is no longer available.";
  }
  }catch{}
  return "";
}


public string Do301Redirect(string url)
{
  try{

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.Status = "301 Moved Permanently";
        HttpContext.Current.Response.AddHeader("Location", url);
        //HttpContext.Current.Response.End();

  }catch{}
  return "";
}



        public string GetDMIVideoLink(string videoData)
        {
            if (string.IsNullOrEmpty(videoData))
                return "no-data"; //string.Empty;


            string cached = HttpRuntime.Cache[videoData] as string;
            if(cached != null)
               return cached;

            try
            {
                string jsUrl = string.Format("http://www.dmotorworks.com.au/dmivideo/deployment/?{0}", videoData);

                WebClient wc = new WebClient();
                string js = wc.DownloadString(jsUrl);

                // Looking for this: "Video.Launch.DataURL": "http://video.dmotorworks.com.au/config_generator/version4/vehicle_video?entityID=DMIASC44081&videoGUID=C691D2AF05346144E040A8C0383253CA",

                Match m = Regex.Match(js, "vehicle_video(.*)\"", RegexOptions.IgnoreCase);
                if (m.Success)
                {

                    string result = string.Format("http://video.dmotorworks.com.au/config_generator/version4/{0}", m.Value.Replace("\"",""));

                    HttpRuntime.Cache.Insert(videoData,
                        result,
                        null,                           
                        DateTime.Now.AddDays(3),
                        System.Web.Caching.Cache.NoSlidingExpiration);

                    return result;
                }

            }
            catch (Exception ex)
            {
return ex.Message;
            }
            return string.Empty;
        }



public string GetSearchPageUrl(string pageNum, string minPrice,
    string maxPrice, string condition, string category, string keywords, string sort)
  {

      return string.Format("/listings?price-min={0}&price-max={1}&condition={2}&q={3}&sort={4}&page={5}&cat={6}",
        minPrice, maxPrice, condition, keywords, sort, pageNum, category);

  }

]]>
</msxml:script>

</xsl:stylesheet>