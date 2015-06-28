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

        public bool SaveCustomerTokenId(string ID, string accessCode)
        {
            DashBoardPaymentProvider dashBoardPaymentProvider = new DashBoardPaymentProvider();
            return dashBoardPaymentProvider.SaveCustomerTokenId(accessCode, ID);
        }
        
        public XPathNodeIterator GetCustomerCreditCardById(string ID)
        {
            DashBoardPaymentProvider dashBoardPaymentProvider = new DashBoardPaymentProvider();
            return dashBoardPaymentProvider.GetCustomerCreditCardById(ID);
        }
        
]]>

  </msxml:script>

</xsl:stylesheet>