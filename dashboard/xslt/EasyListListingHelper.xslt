<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:LiScripts="urn:LiScripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<!-- C# helper scripts -->
		
<msxml:script language="C#" implements-prefix="LiScripts">	
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
<msxml:assembly name="System.Core"/>
<msxml:assembly name="System.Xml.Linq"/>
	
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
<msxml:using namespace="EasyList.Dashboard.Helpers" />
<msxml:using namespace="Componax.ExtensionMethods" />
	
<![CDATA[
		static Logger log = LogManager.GetCurrentClassLogger();
		
  /*public Categories GetCatUI()
		{
			Categories catInfo = null;
			try
			{
				Categories catInfo = EasyList.Dashboard.Helpers.Category.GetCatInfo(176);
			}
			catch(Exception ex)
			{
				log.Error("GetCatUI - Error " + ex.ToString());
			}
			return catInfo;
  }*/
]]>
	
</msxml:script>

</xsl:stylesheet>