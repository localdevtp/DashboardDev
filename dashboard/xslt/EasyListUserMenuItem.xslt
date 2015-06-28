<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:scripts="urn:scripts.this"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
	exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>
<xsl:include href="EasyListEditAPIHelper.xslt" />
<xsl:param name="currentPage"/>

<xsl:template match="/">

	<!--
			Session["easylist-username"] = userName;
            Session["easylist-password"] = password;
            Session["easylist-displayname"] = displayName;
            Session["easylist-usercode"] = userCode;
-->

	<xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
    <xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
	<xsl:variable name="displayName" select="umbraco.library:Session('easylist-displayname')" />
    <xsl:variable name="userCode" select="umbraco.library:Session('easylist-usercode')" />


	<xsl:if test="$userName !='' and umbraco.library:RequestQueryString('logout') !='1'">

		<a class="btn btn-primary user-avatar" data-toggle="dropdown" href="#user-tool">
			<figure>
				<img src="/images/avatar.png" alt="" />
			</figure>
			<span><xsl:value-of select="$displayName" /></span>
			<i class="icon-chevron-down">&nbsp;</i>
		</a>

		<a class="btn btn-danger user-logout" href="/login?logout=1"><i class="icon-switch"><xsl:text>
			</xsl:text></i><span> Logout</span></a>

		<a class="btn btn-info user-help" href="/help"><i class="icon-support"><xsl:text>
			</xsl:text></i><span> Help</span></a>
		<div class="dropdown-menu" id="user-tool">
			<ul>
				<li><a href="/user/profile"><i class="icon-params">&nbsp;</i>My Profile</a></li>
				<li><a href="/user/change-password"><i class="icon-key">&nbsp;</i> Change Password</a></li>
				<li class="user-dropdown-help"><a href="/docs"><i class="icon-support">&nbsp;</i>Help</a></li>
				<li class="user-dropdown-logout"><a href="/login?logout=1"><i class="icon-switch">&nbsp;</i>Logout</a></li>
			</ul>
		</div>

	</xsl:if>

</xsl:template>

	<!-- C# helper scripts -->
	<msxml:script language="C#" implements-prefix="scripts">
<![CDATA[
public string getGravatar(string email) {
    // TODO: Implement Gravatar Hashing
    // e.g. return "http://www.gravatar.com/avatar/"+EMAIL.Trim().ToLower().MD5()
	return "SRC";
}
]]>
	</msxml:script>

</xsl:stylesheet>