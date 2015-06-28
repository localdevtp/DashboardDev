<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:AccScripts="urn:AccScripts.this" 
xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">
	
	
	<xsl:output method="xml" omit-xml-declaration="yes"/>
	<xsl:include href="EasyListStaffHelper.xslt" /> 
	
	<xsl:variable name="CompanyName" select="umbraco.library:Request('company-name')" />
	<xsl:variable name="ActivationState" select="umbraco.library:Request('company-active')" />
	<xsl:variable name="State" select="umbraco.library:Request('company-state')" />
	<xsl:variable name="IsPostBack" select="umbraco.library:Request('IsPostBack')" />
	<xsl:variable name="SortOrder" select="umbraco.library:Request('SortOrder')" />
	<!-- <xsl:variable name="pageNumber" select="umbraco.library:Request('PageNo')" /> -->
	<xsl:variable name="pageNumber">
		<xsl:choose>
		  <xsl:when test="umbraco.library:RequestQueryString('PageNo') &lt;= 1 or string(umbraco.library:RequestQueryString('PageNo')) = '' or string(umbraco.library:RequestQueryString('PageNo')) = 'NaN'">
			<xsl:value-of select="number(1)" />
		  </xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="number(umbraco.library:RequestQueryString('PageNo'))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:param name="currentPage"/>
	
	<xsl:template match="/">
		
		<xsl:variable name="IsAuthorized" select="AccScripts:IsAuthorized('EasySales Admin,ESSalesRep,ESSupport')" /> 
		
		<xsl:choose>
			<xsl:when test="$IsAuthorized = false">
				<div class="alert alert-error">
					<strong>Unfortunately, you are not authorized to access this resource at this point in time.</strong>
				</div>
			</xsl:when>
			<xsl:otherwise>
				
				<xsl:call-template name="LoadPage">
				</xsl:call-template>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template name="LoadPage" >
		
		<xsl:variable name="DealersList" select="AccScripts:GetActiveDealerList($CompanyName, $State, $ActivationState, $pageNumber, $SortOrder)" /> 		
		<xsl:variable name="DealersListCount" select="AccScripts:GetActiveDealerListCount($CompanyName, $State, $ActivationState)" />
		<!-- <textarea>
			 <xsl:value-of select="$DealersListCount" />
		</textarea> -->
		<xsl:choose>
			<xsl:when test="string-length($DealersList/error) &gt; 0">
				<div class="alert alert-error">
					<button data-dismiss="alert" class="close" type="button">×</button>
					<strong>Failed!</strong> <xsl:value-of select="$DealersList/error" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<!-- Manage Dealers Accounts -->
				<xsl:variable name="DelID" select="umbraco.library:RequestQueryString('DelID')" />
				<xsl:if test="string-length($DelID) &gt; 0">
					<div class="alert alert-success">
						<button data-dismiss="alert" class="close" type="button">×</button>
						<strong>Success!</strong> The account <xsl:value-of select="$DelID"/> was deleted successfully!
					</div>
				</xsl:if>
				
				<!--
	  <xsl:if test="count($DealerStaffList/ArrayOfDealer/Dealer) = 0">
	  <div id="easylist-no-results" class="alert alert-error">
	   You don't have any dealer account maintained in the system.
	  </div>
	  </xsl:if>
	  -->   
				
				<div class="widget-box">
					<div class="widget-title"><h2><i class="icon-user-3">&nbsp;</i>Manage Customers</h2></div>
					<div class="widget-content no-padding loading-container">

						<div id="placeholder">

							<xsl:call-template name="loader" />	

							<form id="manage-dealer" method="get" >


								<!-- Result Filtering -->
								<div id="search-filter-dealer">
									<div class="toolbars">
										<a class="btn btn-info active" data-toggle="collapse" href="#search-filter-dealers">
											<i class="icon-filter">&nbsp;</i> Search / Filter / Sort Result
										</a>
										&nbsp;
										<div class="btn-group" id="filter-state">
											<a class="btn btn-info" href="/dealers?company-state=NSW">NSW</a>
											<a class="btn btn-info" href="/dealers?company-state=ACT">ACT</a>
											<a class="btn btn-info" href="/dealers?company-state=NT">NT</a>
											<a class="btn btn-info" href="/dealers?company-state=QLD">QLD</a>
											<a class="btn btn-info" href="/dealers?company-state=SA">SA</a>
											<a class="btn btn-info" href="/dealers?company-state=TAS">TAS</a>
											<a class="btn btn-info" href="/dealers?company-state=VIC">VIC</a>
											<a class="btn btn-info" href="/dealers?company-state=WA">WA</a>
											<a class="btn btn-info" href="/dealers">ALL</a>
										</div>
									</div>
									<div id="search-filter-dealers" class="widget-collapse-options in collapse">
										<div class="widget-collapse-options-inner">
											
											<div class="form-horizontal">
												<!-- <div class="control-group">
												 <label class="control-label">Company Login</label>
												 <div class="controls">
												<input class="text" type="text" maxlength="100" id="company-login" name="company-login" />
												 </div>
											   </div> -->
												
												<div class="control-group">
													<label class="control-label">Keyword </label>
													<div class="controls">
														<input class="text input-xlarge" type="text" maxlength="150" width="250" id="company-name" name="company-name">
															<xsl:attribute name="value">
																<xsl:value-of select="$CompanyName" />
															</xsl:attribute>
														</input>
														<br />
														<small>e.g. Company name, user name, postcode, phone number</small>
													</div>
												</div>
												
												<!-- <div class="control-group">
												   <label class="control-label">Company Registration</label>
												   <div class="controls">
												  <select name="company-reg-type" id="company-reg-type" style="width:86px">
													<xsl:call-template name="optionlist">
												   <xsl:with-param name="options">,ABN,ACN,RBN</xsl:with-param>
												   <xsl:with-param name="value">
													 
												   </xsl:with-param>
													</xsl:call-template>
												  </select>
												  <input class="text" style="margin-left:5px;width:120px" type="text" maxlength="50" id="company-reg-no" name="company-reg-no" />
												   </div>
												 </div> -->
												
												<div class="control-group">
													<label class="control-label">Status</label>
													<div class="controls">
														<select name="company-active" id="company-active" class="input-large">
															<xsl:call-template name="optionlist">
																<xsl:with-param name="options">All,Activated,Pending Activation,Not Activated</xsl:with-param>
																<xsl:with-param name="value">
																	
																</xsl:with-param>
															</xsl:call-template>
														</select>
													</div>
												</div>
												
												<div class="control-group">
													<label class="control-label">Sort Result by</label>
													<div class="controls">
														<select name="SortOrder" id="SortOrder" class="input-large">
															<xsl:call-template name="optionlist">
																<xsl:with-param name="options">Company Name,Company Login,Email,State,Post Code,City</xsl:with-param>
																<xsl:with-param name="value">
																</xsl:with-param>
															</xsl:call-template>
														</select>
													</div>
												</div>
												
												<div class="control-group hidden">
													<label class="control-label">State</label>
													<div class="controls">
														<select name="company-state" id="company-state" class="input-medium">
															<xsl:call-template name="optionlist">
																<xsl:with-param name="options">All States,ACT,NSW,NT,QLD,SA,TAS,VIC,WA</xsl:with-param>
																<xsl:with-param name="value">
																</xsl:with-param>
															</xsl:call-template>
														</select>
													</div>
												</div>
												<input type="hidden" id="IsPostBack" name="IsPostBack" value="true" />
												<div class="control-group form-actions">
													<div class="controls">
														<button type="submit" id="dealer-search" class="btn btn-large">Submit</button>
														<!-- <a class="btn" id="dealer-search" href="javascript:submit()">Search/Filter</a> -->
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<!-- /Result Filtering -->
								<xsl:if test="count($DealersList/ArrayOfUser/User) &gt; 0">
									<table class="footable footable-compact">
										<thead>
											<tr>
												<th style="text-align:left;width:100px;max-width:100px;" data-class="expand" data-sort-ignore="true">Company Login</th>
												<th style="text-align:left;min-width:100px;" data-sort-ignore="true">Company Name</th>
												<!-- <th data-hide="phone">Company Registration</th> -->
												<th style="text-align:left" data-hide="phone,tablet" data-sort-ignore="true">Email</th>
												<th data-hide="phone,tablet" data-sort-ignore="true">Contact Phone</th>
												<th data-hide="phone,tablet" data-sort-ignore="true">State</th>
												<th data-hide="phone,tablet" data-sort-ignore="true">Post Code</th>
												<th data-hide="phone,tablet" data-sort-ignore="true">City</th>
												<th style="width:120px" data-hide="phone" data-sort-ignore="true">Date Created</th>
												<th style="width:80px" data-sort-ignore="true">Status</th>
											</tr>
										</thead>
										<tbody>
											<xsl:for-each select="$DealersList/ArrayOfUser/User">
												<xsl:call-template name="Dealers-List">
													<xsl:with-param name="Dealer" select="."></xsl:with-param>
												</xsl:call-template>
											</xsl:for-each>			
										</tbody>
									</table>
								</xsl:if>
								<xsl:if test="count($DealersList/ArrayOfUser/User) = 0">
									<div class="alert alert-info" style="margin:10px">
										Please search/filter customer
									</div>
								</xsl:if>
																
							</form>
						
							<xsl:call-template name="Pagination">
								<xsl:with-param name="numberOfPages"><xsl:value-of select="$DealersListCount"/></xsl:with-param>
							</xsl:call-template> 

						</div>
						<!-- /placeholder -->

					</div>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="Dealers-List" match="Dealer">
		<xsl:param name="Dealer"/>
		<tr>
			<td style="text-align:left;width:100px;max-width:100px;" class="text-ellipsis">
				<a class="edit-dealder" href="/dealers/edit?id={$Dealer/LoginName}">
					<xsl:attribute name="title">
						<xsl:value-of select="$Dealer/LoginName"/>
					</xsl:attribute>
					<xsl:value-of select="$Dealer/LoginName"/>
				</a>
			</td>
			<td style="text-align:left">
				<xsl:value-of select="$Dealer/CompanyName"/>
			</td>
			<!--  <td>
	  <xsl:value-of select="$Dealer/CompanyRegistration"/>
   </td> -->
			<td style="text-align:left">
				<xsl:value-of select="$Dealer/EmailAddress"/>
			</td>
			<td>
				<xsl:value-of select="$Dealer/ContactPhone"/>
			</td>
			<td>
				<xsl:value-of select="$Dealer/State"/>
			</td>
			<td>
				<xsl:value-of select="$Dealer/PostalCode"/>
			</td>
			<td>
				<xsl:value-of select="$Dealer/CityTown"/>
			</td>
			<td>
				<xsl:value-of select="umbraco.library:FormatDateTime($Dealer/DateCreated, 'yyyy-MM-dd HH:mm:ss')" />
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$Dealer/UserActivationState = 'Activated'">
						<span class="label-status active" title="Activated">Activated</span>
					</xsl:when>
					<xsl:when test="$Dealer/UserActivationState = 'PendingActivation'">
						<span class="label-status pending" title="Pending Activation">Pending Activation</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="label-status" title="Not Activated">Not Activated</span>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template name="Pagination" match="Pagination">
		<!-- Add paging links -->    
		<xsl:param name="numberOfPages"/>
		<!-- <xsl:variable name="numberOfPages" select="20" /> -->
		<!-- <xsl:variable name="pageNumber" select="$PageNo" /> -->
		
		<xsl:if test="$numberOfPages > 1">  
			
			<div id="easylist-pagination" class="pagination pagination-centered">
				<ul id="easylist-page-links">
					
					<xsl:variable name="prevPageNum" select="$pageNumber - 1" />
					<xsl:variable name="nextPageNum" select="$pageNumber + 1" />
					
					<!-- Previous link -->  
					<!-- <xsl:if test="$pageNumber > 1">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $prevPageNum)}"> 
								<span class="arrow-w">&nbsp;</span> Previous Page &nbsp;</a>
						</li>
					</xsl:if> -->
					
					<!-- <xsl:if test="$pageNumber = 1">
							 <li>
					<a class="more-results" href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}">
					&nbsp; View More Search Results <span class="arrow-e">&nbsp;</span>
					</a>
					</li> 
						  </xsl:if> -->
					
					<!-- Numbered Pages -->
					
					<xsl:variable name="startPage">
						<xsl:choose>
							<xsl:when test="$numberOfPages &lt; 12">1</xsl:when>
							<xsl:when test="$pageNumber &lt; 7">1</xsl:when>
							<xsl:when test="$numberOfPages - $pageNumber &lt; 5">
								<xsl:value-of select="$numberOfPages -10" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$pageNumber -6" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="endPage">
						<xsl:choose>
							<xsl:when test="$numberOfPages &lt; 12">
								<xsl:value-of select="$numberOfPages" />
							</xsl:when>
							<xsl:when test="$pageNumber &lt; 7">11</xsl:when>
							<xsl:when test="$pageNumber +6 &gt; $numberOfPages">
								<xsl:value-of select="$numberOfPages" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$pageNumber +6" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:if test="$pageNumber != '1'"> 
						<li class="first-page">
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, 1)}">
							<i class="icon-first">&nbsp;</i><span class="hidden-phone">Page 1</span></a>
						</li>
					
						<li class="prev-page">
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $prevPageNum)}">
							<i class="icon-backward">&nbsp;</i></a>
						</li>
					</xsl:if>
					
					<!--
					<xsl:if test="$startPage &gt; 1">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, 1)}">1...</a>
						</li>
					</xsl:if>
					-->
					
					<xsl:call-template name="for.loop">
						<xsl:with-param name="i" select="$startPage" />
						<xsl:with-param name="page" select="$pageNumber +1"></xsl:with-param>
						<xsl:with-param name="count" select="$endPage"></xsl:with-param>
					</xsl:call-template> 
					
					<!--
					<xsl:if test="$numberOfPages &gt; $endPage">
						<li>
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $numberOfPages)}" >...<xsl:value-of select="$numberOfPages" /></a>
						</li>
					</xsl:if>
					-->
					
					<xsl:if test="$pageNumber &lt; $numberOfPages"> 
						<!-- <li>
							<a class="next-page" href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}">
								&nbsp; Next Page <span class="arrow-e">&nbsp;</span></a>
						</li> -->
						<li class="next-page">
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $nextPageNum)}">
							<i class="icon-forward">&nbsp;</i></a>
						</li>
							<li class="last-page">
							<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $numberOfPages)}">
							<span class="hidden-phone">Page <xsl:value-of select="$numberOfPages" /></span>&nbsp;<i class="icon-last">&nbsp;</i></a>
						</li>
					</xsl:if>
				</ul>
			</div>  
		</xsl:if>  
		
	</xsl:template >
	
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
					<xsl:otherwise>Select</xsl:otherwise>
				</xsl:choose>
			</option>
		</xsl:for-each>
		
	</xsl:template>
	
	<xsl:template name="for.loop">
		<xsl:param name="i"/>
		<xsl:param name="count"/>
		<xsl:param name="page"/>
		<xsl:if test="$i &lt;= $count">
			<li>  
				<xsl:choose>
					<xsl:when test="$page = ($i + 1)">
						<xsl:attribute name="class"><xsl:value-of select="'current'"/></xsl:attribute>
					</xsl:when>
					<xsl:when test="($page &gt; ($i + 2)) or ($page &lt; $i)">
						<xsl:attribute name="class"><xsl:value-of select="'hidden-tablet hidden-phone'"/></xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<a href="{AccScripts:GetDealerPageURL($CompanyName, $State, $ActivationState, $SortOrder, $i)}" >
					<xsl:value-of select="$i" />
				</a>
			</li>
		</xsl:if>
		<xsl:if test="$i &lt;= $count">
			<xsl:call-template name="for.loop">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1" />
				</xsl:with-param>
				<xsl:with-param name="count">
					<xsl:value-of select="$count"/>
				</xsl:with-param>
				<xsl:with-param name="page">
					<xsl:value-of select="$page"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- LOADING TEMPLATE -->
	<xsl:template name="loader">
		<!-- Loaders -->
		<div id="loading-bg">
			<xsl:text>
			</xsl:text>
		</div>
		<div id="loading" style="display:none">
			<img class="retina" src="/images/spinner.png" />
		</div>
		<!-- /Loaders -->	
	</xsl:template>
	<!-- /LOADING TEMPLATE -->
	
</xsl:stylesheet>
