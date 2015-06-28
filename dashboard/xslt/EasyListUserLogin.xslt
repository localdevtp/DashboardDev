<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:scripts="urn:scripts.this" 
xmlns:RESTscripts="urn:RESTscripts.this" 
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">



 
<xsl:output method="html" omit-xml-declaration="yes"/>


<!-- C# helper scripts -->
<msxml:assembly name="NLog" />
<msxml:assembly name="System.Xml.Linq"/>
<msxml:assembly name="EasyList.Common.Helpers"/>

<xsl:include href="EasyListEditAPIHelper.xslt" />
<xsl:include href="EasyListRestHelper.xslt" />

<!-- Variables -->

<xsl:variable name="successUrl">
	<xsl:variable name="RequestParam" select="umbraco.library:RequestQueryString('q')"/>
	<xsl:variable name="RequestParamClean" select="umbraco.library:Replace($RequestParam,'~','=')"/>
	<xsl:choose>
		<xsl:when test="umbraco.library:RequestQueryString('go') !=''">
			<xsl:value-of select="umbraco.library:RequestQueryString('go')"/>?<xsl:value-of select="$RequestParamClean" />
		</xsl:when>
		<xsl:when test="/macro/landingPage != ''">
			<xsl:value-of select="umbraco.library:NiceUrl(/macro/landingPage)" />
		</xsl:when>
		<xsl:otherwise>/</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="logout">
	<xsl:choose>
		<xsl:when test="umbraco.library:RequestQueryString('logout') ='1'">1</xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="Login" select="umbraco.library:RequestForm('Login')" />
<xsl:variable name="UserName" select="umbraco.library:RequestForm('easylist-user')" />
<xsl:variable name="PublicFlag" select="umbraco.library:RequestForm('public-flag')" />
<xsl:variable name="Password" select="umbraco.library:RequestForm('easylist-Password')" />
<xsl:variable name="ConfirmPassword" select="umbraco.library:RequestForm('easylist-ConfirmPassword')" />
<xsl:variable name="NewSecPhrase" select="umbraco.library:RequestForm('easylist-NewSecPhrase')" />
<xsl:variable name="OTP" select="umbraco.library:RequestForm('easylist-OTP')" />
<xsl:variable name="QnA" select="umbraco.library:RequestForm('easylist-QnA')" />
<xsl:variable name="MobileNo" select="umbraco.library:RequestForm('easylist-MobileNo')" />
<xsl:variable name="Email" select="umbraco.library:RequestForm('easylist-Email')" />
<xsl:variable name="ViewState" select="umbraco.library:RequestForm('ViewState')" />
<xsl:variable name="ActivationKey" select="umbraco.library:RequestQueryString('ActivationKey')" />


<xsl:variable name="logonResponse" select="RESTscripts:LogonV2($UserName, $Login, $PublicFlag, $OTP, $Password, $QnA, $MobileNo, $Email, $ViewState, $ActivationKey, $ConfirmPassword, $NewSecPhrase )" />


<xsl:variable name="AccInfo" select="$logonResponse/AccountInfo" />

	

<!-- 
<xsl:variable name="logonResponse">
	<xsl:choose>
		<xsl:when test="$Login != ''">  
			<xsl:value-of select="RESTscripts:LogonV2($UserName, $Login, $PublicFlag, $OTP, $Password, $QnA, $MobileNo, $Email, $ViewState, $ActivationKey, $ConfirmPassword, $NewSecPhrase )" />
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="AccInfo">
	<xsl:choose>
		<xsl:when test="$logonResponse != ''">  
			<xsl:value-of select="$logonResponse/AccountInfo" />
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable> -->

<!-- Start templates -->
<xsl:param name="currentPage"/>



<xsl:template match="/">

	
	<!-- debugging 

	<textarea>
		<xsl:value-of select="$AccInfo/UserID" /> // 
		<xsl:value-of select="$AccInfo/DisplayName" /> // 
		<xsl:value-of select="$AccInfo/UserCode" /> //
		<xsl:value-of select="$AccInfo/UserSignature" /> //
		<xsl:value-of select="$AccInfo/UserSignatureDateTime" /> 
	</textarea> 
	
	 debugging -->
	
	<!-- Logout -->
	<xsl:if test="$logout = '1' and $Login = ''">
		<!-- Clear the logged on user session vars -->
		<xsl:value-of select="scripts:SetUserSessionVars('', '', '', '', '')" />
		<xsl:value-of select="scripts:ClearSessionInfoVars()" />
		
		<div class="login-alert alert alert-info">
			<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
			You have logged out.
		</div>
	</xsl:if>

	<xsl:choose>
		<xsl:when test="string-length($ActivationKey) &gt; 0 and $Login != 'Submit_EmailActivation'">
			<xsl:choose>
				<xsl:when test="$AccInfo/HasError = 'true'">  
					<!--<textarea><xsl:value-of select="$AccInfo/HasError" /></textarea>-->
					<xsl:variable name="Redirect" select="RESTscripts:RedirectTo('/')" />
					<div class="login-alert alert alert-error flash">
						<strong>Failed</strong> Invalid activation key!
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="NonAct_ActivateAcc" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		
		
		<!-- First Login Page -->
		<xsl:when test="$Login = 'Login' or $Login = 'LoginUserName'">
			<!--
			<xsl:variable name="logonResponse" select="scripts:LogonUser($UserName,$password)" />-->
			<!--
			<textarea>
				<xsl:value-of select="$logonResponse/AccountInfo/NextLoginTemplate" />
				<xsl:value-of select="$logonResponse/AccountInfo/UserActivationState" />
			</textarea>
			-->
			<xsl:choose>
				<!-- User login using email address -->
				<xsl:when test="$AccInfo/NextLoginTemplate = 'LoginSelectUserName'">  
					<xsl:call-template name="Username-Select-Form" />
				</xsl:when>
				<xsl:when test="$AccInfo/NextLoginTemplate = 'NonAct_Verify'">  
					<xsl:choose>
						<xsl:when test="$AccInfo/UserActivationState = 'PendingActivation'">  
							<div class="login-alert alert alert-error flash">
								<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
								<strong>Failed</strong> Your account is pending activation. <br/>Please check your mailbox and click the activation link inside to activate your account!
							</div>
							<xsl:call-template name="First-Login-Form" />
						</xsl:when>
						<xsl:otherwise> 
						
							<xsl:call-template name="NonAct_Verify" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$AccInfo/NextLoginTemplate = 'Act_Public_OTP'">  
					<xsl:call-template name="Act_Public_OTP" />
				</xsl:when>
				<xsl:when test="$AccInfo/NextLoginTemplate = 'Act_SecPhrase_Password'">  
					<xsl:call-template name="Act_SecPhrase_Password" />
				</xsl:when>
				<xsl:otherwise>
					
					<div class="login-alert alert alert-error flash">
						<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
						<strong>Login Failed</strong> Please check your user name and try again.
					</div>
					<xsl:call-template name="First-Login-Form" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<!-- User request activation, email send for verification -->
		<xsl:when test="$Login = 'Submit_Activation'">
			<xsl:choose>
				<xsl:when test="string-length($AccInfo/AccountActivationLink) &gt; 0">
					<!--https://dashboard.easylist.com.au/login?ActivationKey=<xsl:value-of select="$AccInfo/AccountActivationLink" /> -->
					<div class="alert alert-success">
						<strong>Success!</strong> Please check your mailbox and click the activation link inside to activate your account!
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="login-alert alert alert-error flash">
						<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
						<strong>Email activation failed</strong> Please verify your info and try again.
					</div>
					<xsl:call-template name="NonAct_Verify" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<!-- User click activation from Email, submit to activate -->
		<xsl:when test="$Login = 'Submit_EmailActivation'">
			<xsl:choose>
				<xsl:when test="$AccInfo/HasError='true'">  
					<div class="login-alert alert alert-error flash">
						<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
						<strong>Account activation Failed</strong> Please verify your Password/OTP and try again.
					</div>
					<xsl:call-template name="NonAct_ActivateAcc" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="activated" />
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:when>
		
		<xsl:when test="$Login = 'Submit_OTP'">
			<xsl:choose>
				<xsl:when test="$AccInfo/NextLoginTemplate = 'Act_SecPhrase_Password'">  
					<xsl:call-template name="Act_SecPhrase_Password" />
				</xsl:when>
				<xsl:otherwise>
					<div class="login-alert alert alert-error flash">
						<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
						<strong>Login Failed</strong> Please verify your OTP and try again.
					</div>
					<xsl:call-template name="Act_Public_OTP" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<xsl:when test="$Login = 'Submit_Password'">
			
			<!-- debugging 
			<textarea>
				<xsl:value-of select="$AccInfo" />
			</textarea>
			 debugging -->
			
			<xsl:choose>
				<xsl:when test="string-length($AccInfo/UserSignature) &gt; 0">
					<xsl:variable name="login-name" select="$AccInfo/UserID" />
					<xsl:variable name="user-name" select="$AccInfo/DisplayName" />
					<xsl:variable name="user-code" select="$AccInfo/UserCode" />
					<xsl:variable name="user-signature" select="$AccInfo/UserSignature" />
					<xsl:variable name="user-signatureDT" select="$AccInfo/UserSignatureDateTime" />
					
					<!-- Set the logged on user session vars -->
					<xsl:value-of select="scripts:SetUserSessionVars($login-name, $user-name, $user-code,  $user-signature,  $user-signatureDT)" />
					<!-- Redirect to the target URL -->
					<xsl:value-of select="scripts:RedirectTo($successUrl)" />
				</xsl:when>
				<xsl:otherwise>
					<div class="login-alert alert alert-error flash">
						<button type="button" class="close" data-dismiss="alert"><xsl:text>&#215;</xsl:text></button>
						<!-- <strong>Login Failed</strong> Please verify your Password and try again. -->
						<strong>Login Failed</strong> <xsl:value-of select="$AccInfo/ErrorMessage" />
					</div>
					<xsl:call-template name="Act_SecPhrase_Password" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		
		<xsl:otherwise>
			<xsl:call-template name="First-Login-Form" />
		</xsl:otherwise>
	</xsl:choose>
	
	



</xsl:template>

<!-- <xsl:template name="loginForm">
	<xsl:call-template name="First-Login-Form" />
</xsl:template> -->

<xsl:template name="First-Login-Form">

 
	<form method="post" >
		<div class="login-form stage-1">
			
			<div class="control-group">
				<input type="text" maxlength="100" class="login-field" name="easylist-user" id="easylist-user" placeholder="Enter your username/email" />
				<label class="login-field-icon icon-user" for="login-name">&nbsp;</label>
				<label class="checkbox" for="public-flag">
					<input type="checkbox" id="public-flag" name="public-flag" />This is a public or shared device. &nbsp; <a href="" onclick="javascript:return false;" data-toggle="tooltip" title="If you're using a public PC or shared device, select this option to protect your account from being accessed by other users. Note that we will need to send you an SMS authentication code if you select this option, so please make sure you have your phone handy!">what's this?</a>
				</label>
			</div>
			<br />
			<div class="control-group">
				<button type="submit" name="Login" value="Login" class="btn btn-large btn-success btn-block">Existing Advertiser?  Login Now</button>
			</div>
			<a class="btn btn-info btn-large btn-block" href="/new-user.aspx">New Advertiser? Start Now</a>
			<p><br/>If you are a first time advertiser, please click the green ‘New Advertiser’ button above to begin placing your ad.</p>
			<p>If you are already an advertiser, please enter your existing Tradingpost username above to access your ads.</p>
			<p>Your username is usually either your email address for private advertisers, or for commercial advertisers it is the username we sent you when you were first registered for EasyList Ad Management.</p>
			<p>Having problems? <a href="http://www.tradingpost.com.au/help/contact-us">Contact our support team</a></p>
			
		</div>
		
		
	</form>
</xsl:template>

<!-- If user login by email address, prompt for list of user name -->
<xsl:template name="Username-Select-Form">
	<form method="post" >
		<div class="login-form stage-2">
			<p>We found more than one account for the email address entered. <br/> Please select the account you'd like to login to:</p>
			<div class="control-group">
				<select class="drop-down"  name="easylist-user" id="easylist-user" >
					<xsl:call-template name="optionlist">
						<xsl:with-param name="options"><xsl:value-of select="$AccInfo/UserIDList" /></xsl:with-param>
						<xsl:with-param name="value">
						</xsl:with-param>
					</xsl:call-template>
				</select>
			</div>
			<input type="hidden" id="public-flag" name="public-flag" value="{$PublicFlag}">
			</input>
			<br />
			<div class="control-group">
				<button type="submit" name="Login" value="LoginUserName" class="btn btn-large btn-primary btn-block">Continue</button>
			</div>
		</div>
	</form>
</xsl:template>

<!-- Account activation -->
<xsl:template name="NonAct_ActivateAcc">
	<form method="post" autocomplete="off">
		<div class="login-form stage-2">
			<h4>
				<i class="icon-user">&nbsp;</i>
				<strong>
					<xsl:value-of select="$AccInfo/UserID" />
				</strong>
			</h4>
			<xsl:call-template name="otp" />
			<br/>
			<xsl:call-template name="new-password" />
			<xsl:call-template name="new-secure-phrase" />
			<input type="hidden" id="easylist-user" name="easylist-user" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/UserID" />
                </xsl:attribute>
			</input>
			<div class="control-group">
				<button type="submit" name="Login" value="Submit_EmailActivation" class="btn btn-large btn-primary btn-block">Submit</button>
			</div>
		</div>
	</form>

</xsl:template>

<!-- Non-Activate user prompt for ex-password,sec answer if exists, mobile no and email -->
<xsl:template name="NonAct_Verify">
	<form method="post" autocomplete="off">
		<div class="login-form stage-2">
			<h4>
				<i class="icon-user">&nbsp;</i>
				<strong>
					<xsl:value-of select="$UserName" />
				</strong>
			</h4>
			<p>
			We're implementing security upgrades, and need you to confirm your account details.
			</p>
			<xsl:call-template name="password" />
			
			<!-- <xsl:if test="string-length($AccInfo/SecQuestion) &gt; 0">
				<xsl:call-template name="qna" />
			</xsl:if> -->
			
			<p>Please enter your personal mobile phone number. We will use this to send you an SMS with a One Time Pin you'll need to enter.</p>
			<xsl:call-template name="mobilenumber" />
			
			<!-- <p>Please enter your personal email address. We will use this to send you a special verification link you'll need to click.</p>
			<xsl:call-template name="email" /> -->
			
			<p>
			A re-activation email message will be sent to <b><xsl:value-of select="$AccInfo/EmailAdd" /></b>. 
			<br/>
			<br/>
			Please follow the instructions in that message to finish your account configuration.
			</p>
			
			<input type="hidden" id="easylist-user" name="easylist-user" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/UserID" />
                </xsl:attribute>
			</input>
			<div class="control-group">
				<button type="submit" name="Login" value="Submit_Activation" class="btn btn-large btn-primary btn-block">Submit</button>
			</div>
		</div>
	</form>
	<div class="login-footer">
		<a class="btn btn-small" href="/action/password-recovery.aspx">Forgotten your password?</a>
	</div>
</xsl:template>

<!-- Activated user access from public/shared PC, prompt for OTP -->
<xsl:template name="Act_Public_OTP">
	<form method="post" autocomplete="off">
		<div class="login-form stage-2">
			<h4>
				<i class="icon-user">&nbsp;</i>
				<strong>
					<xsl:value-of select="$UserName" />
				</strong>
			</h4>
			
			<xsl:call-template name="otp" />
			
			<input type="hidden" id="easylist-user" name="easylist-user" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/UserID" />
                </xsl:attribute>
			</input>
			<input type="hidden" id="ViewState" name="ViewState" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/LogonViewState" />
                </xsl:attribute>
			</input>
			
			<div class="control-group">
				<button type="submit" name="Login" value="Submit_OTP" class="btn btn-large btn-primary btn-block">Submit</button>
			</div>
		</div>
	</form>
</xsl:template>

<!--  Activated user access from own PC, or public/shared PC, already validatio OTP, prompt got password display sec phrase -->
<xsl:template name="Act_SecPhrase_Password">
	<form method="post" autocomplete="off">
		<div class="login-form stage-2">
			<h4>
				<i class="icon-user">&nbsp;</i>
				<strong>
					<xsl:value-of select="$AccInfo/UserID" />
				</strong>
			</h4>
			
			<xsl:if test="$AccInfo/SecPhrase != ''">
				<xsl:call-template name="secure-phrase" />
			</xsl:if>
			<!-- <xsl:call-template name="secure-phrase" /> -->
			
			<xsl:call-template name="password" />
			
			<input type="hidden" id="easylist-user" name="easylist-user" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/UserID" />
                </xsl:attribute>
			</input>
			<input type="hidden" id="ViewState" name="ViewState" >
				<xsl:attribute name="value">
					<xsl:value-of select="$AccInfo/LogonViewState" />
                </xsl:attribute>
			</input>
			<div class="control-group">
				<button type="submit" name="Login" value="Submit_Password" class="btn btn-large btn-primary btn-block">Submit</button>
			</div>
		</div>
	</form>
	<div class="login-footer">
		<a class="btn btn-small">
			<xsl:attribute name="href">/action/password-recovery.aspx?UserID=<xsl:value-of select="$AccInfo/UserID" /></xsl:attribute>
			Forgotten your password?
		</a>
	</div>
</xsl:template>

<!--......................................... Controls template .........................................-->
<xsl:template name="secure-phrase">
	<p>
		You should always see your secret word displayed below before entering your password.
		<br /><br /><strong class="important">If you are ever asked for your password but do not see this warning and your secret word, do not proceed!</strong>
		<br /><br />
	</p>
	
	<div class="secure-code">
		<i class="icon-key">&nbsp;</i>YOUR SECRET WORD
		<strong>
			<xsl:value-of select="$AccInfo/SecPhrase" />
		</strong>
	</div>
</xsl:template>

<xsl:template name="new-secure-phrase">
	<div class="control-group">
		<label class="control-label"><span class="important required">*</span><strong>Please enter your secret word</strong>&nbsp;&nbsp;<i class="icon-info-2" data-toggle="tooltip" title="" data-original-title="The secret word you enter here will be displayed by the Tradingpost website every time we prompt you to enter your password, so you can be sure it's us asking for your password, and not a phishing website.">&nbsp;</i>
		</label>
		<div class="controls">
			<input type="text" name="easylist-NewSecPhrase" id="easylist-NewSecPhrase" value="" class="login-field no-icon">
				<xsl:attribute name="data-validate"><![CDATA[{required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter your secret word!', regex:'Please enter your secret word'}}]]></xsl:attribute>
			</input>
			<i class="icon-warning important">&nbsp;</i>Your secret word should never be the same as your password, user name or email address, and should not provide any hints to your password!
		</div>
	 </div>
	 <br/>
</xsl:template>
	
<xsl:template name="otp">
	
	<p>
		We just sent an SMS to your mobile with a 4-digit number.
		<br /><br />Enter the number below (Ref = <strong><span id="OTPLoginRefCode"><xsl:value-of select="$AccInfo/OTPReferenceCode" /></span></strong>):
	</p>
	
	<div class="control-group">
		<input type="text" id="easylist-OTP" name="easylist-OTP" class="login-field required" value="" placeholder="Enter the 4-digit number">
			<xsl:attribute name="data-validate"><![CDATA[{regex:/^[\d]{4}$/ , messages: { regex:'The OTP code should be 4-digits between 0-9.'}}]]></xsl:attribute>
		</input>
		<label class="login-field-icon icon-asterisk" for="otp">&nbsp;</label>
	</div>
	
	<div class="control-group">
		<a id="request-otp" class="btn btn-block" href="#" tabindex="-1">Didn't receive the SMS? <span class="inner-btn btn-success">Resend</span></a>
	</div>
</xsl:template>
	
<xsl:template name="qna">
	<p><xsl:value-of select="$AccInfo/SecQuestion" /></p>
	<div class="control-group">
		<input type="text" id="easylist-QnA" name="easylist-QnA" class="login-field required" value="" placeholder="Security answer" />
		<label class="login-field-icon icon-shield" for="easylist-qna">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="mobilenumber">
	<div class="control-group">
		<input type="text" id="easylist-MobileNo" name="easylist-MobileNo" class="login-field required" value="" placeholder="Mobile number">
			<xsl:attribute name="data-validate">{required: true, regex:/^(?=.*04)((?:\s*\d\s*)){10}$/, messages: {regex: 'The contact mobile entered is invalid'}}</xsl:attribute>
		</input>
		<label class="login-field-icon icon-mobile" for="easylist-mobilenumber">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="email">
	<div class="control-group">
		<input type="text" id="easylist-Email" name="easylist-Email" class="login-field required email" value="" placeholder="E-mail" />
		<label class="login-field-icon icon-envelop" for="easylist-email">&nbsp;</label>
	</div>
</xsl:template>
	
<xsl:template name="password">
	<div class="control-group">
		<input type="password" id="easylist-Password" name="easylist-Password" maxlength="30" class="login-field required" value="" placeholder="Enter your password" />
		<label class="login-field-icon icon-lock" for="easylist-pass">&nbsp;</label>
	</div>	
</xsl:template>

<xsl:template name="new-password">
	<!-- <div class="control-group">
		<input type="password" id="easylist-Password" name="easylist-Password" maxlength="30" class="login-field required" value="" placeholder="Password" />
		<label class="login-field-icon icon-lock" for="easylist-pass">&nbsp;</label>
	</div> -->
	 <div class="control-group">
		<label class="control-label"><span class="important">*</span> New Password</label>
		<div class="controls">
			<input type="password" name="easylist-Password" id="easylist-Password" value="" class="login-field no-icon" data-password-meter="true" data-password-meter-placement="top">
				<!--<xsl:attribute name="data-validate"><![CDATA[{regex:/^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[\w\s!@#$%^&*]{8,20}$/ ,required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter new password!', regex:'Please enter at least 8 characters with one or more of each: uppercase[A-Z], lowercase[a-z], number[0-9] and symbols[!@#$%^&]'}}]]></xsl:attribute>-->
				<xsl:attribute name="data-validate">{required: true, minlength: 8, maxlength: 20, messages: {required: 'Please enter new password!'}}</xsl:attribute>
			</input>
		</div>
	  </div>
	  <div class="control-group">
		<label class="control-label"><span class="important">*</span> Re-type New Password</label>
		<div class="controls">
			<input type="password" name="easylist-ConfirmPassword" id="easylist-ConfirmPassword" value="" class="login-field no-icon">
				<xsl:attribute name="data-validate">{equalTo: '#easylist-Password', minlength: 8, maxlength: 20}</xsl:attribute>
			</input>
		</div>
	  </div>
</xsl:template>

<xsl:template name="activated">
	<div class="login-form">
		<h4>
			<i class="icon-user">&nbsp;</i>
			<strong>
				Hi <xsl:value-of select="$UserName" />
			</strong>
		</h4>
		<p>
			Congratulation on activating your Tradingpost Dashboard!<br/><br />
			You are now able to use Tradingpost Dashboard for easy management of your ads listing.
		</p>
		<br />
		<div class="control-group">
			<a class="btn btn-success btn-large btn-block" href="/"><i class="icon-dashboard">&nbsp;</i> Go to Dashboard</a>
		</div>
	</div>	
</xsl:template>


<!-- Drop-down options template -->
<xsl:template name="optionlist">
	<xsl:param name="options"/>
	<xsl:param name="value"/>
	
	<xsl:for-each select="umbraco.library:Split($options,',')//value">
		<option>
			<xsl:attribute name="value">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<!-- check to see whether the option should be selected-->
			<xsl:if test="$value =.">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test=". !=''">
					<xsl:value-of select="." />
				</xsl:when>
				<xsl:otherwise>[Select an option]</xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:for-each>
</xsl:template>
	
<!--......................................... Controls template .........................................-->
	
</xsl:stylesheet>