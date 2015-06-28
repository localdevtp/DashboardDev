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

		
	<xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
    <xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />

<xsl:template name="category-tree" >
	
	
	<xsl:variable name="data" select="scripts:GetAllCategories($userName,$password)" />
	
	<!-- debugging 
	<textarea>
		<xsl:copy-of select="$data" />
	</textarea>
-->
	
	<div id="easylist-categories">
		
	
	<ul class="drill-down dashboard-list select-tree">
		<xsl:for-each select="$data/ArrayOfCategoryInfo/CategoryInfo">
			<li>
				
				
				<xsl:choose>
					<xsl:when test="./UIEditor !=''">
						<label class="radio">
							<input type="radio" name="listing-category" class="link category-radio">
							<xsl:attribute name="data-category-path">
								<xsl:value-of select="./Path" />
							</xsl:attribute>
							<xsl:attribute name="data-category-name">
								<xsl:value-of select="./Name" />
							</xsl:attribute>
							<xsl:attribute name="data-category-id">
								<xsl:value-of select="./ID" />
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="./UIEditor ='AutomotiveListing'">AutomotiveListing</xsl:when>
									<xsl:otherwise>GM</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:value-of select="./UIEditor" />-->
							</xsl:attribute>
							
							<xsl:attribute name="id">listing-category-<xsl:value-of select="./ID" /></xsl:attribute>
							
							<xsl:value-of select="./Name" />
								
							</input>
						</label>
							
					</xsl:when>
					<xsl:otherwise>
						
						<a href="#">
							<xsl:value-of select="./Name" />
							<xsl:if test="count(./Categories/CategoryInfo) &gt; 0">
								<span class="todo-actions"><i class="halflings-icon chevron-right"><xsl:text>
									</xsl:text></i>
								</span>
							</xsl:if>
						</a>
						
					</xsl:otherwise>
				</xsl:choose>
					
					
					<!--
				
				<xsl:if test="./UIEditor != ''">
				
						<input type="radio" name="listing-category" class="link category-radio">
							<xsl:attribute name="data-category-path">
								<xsl:value-of select="./Path" />
							</xsl:attribute>
							<xsl:attribute name="data-category-name">
								<xsl:value-of select="./Name" />
							</xsl:attribute>
							<xsl:attribute name="data-ui-editor">
								<xsl:value-of select="./UIEditor" />
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="./UIEditor" />
							</xsl:attribute>
							
							<xsl:attribute name="id">listing-category-<xsl:value-of select="./ID" /></xsl:attribute>
							
						</input>
						
					</xsl:if>
				
	
				<a href="#">
					
					
					<xsl:if test="./UIEditor != ''">
						<xsl:attribute name="class">has-checkbox</xsl:attribute>
					</xsl:if>
					
					
					<xsl:value-of select="./Name" />
		
					<xsl:if test="count(./Categories/CategoryInfo) &gt; 0">
						<span class="todo-actions"><i class="halflings-icon chevron-right"><xsl:text>
							</xsl:text></i>
						</span>
					</xsl:if>
				</a>
				-->
				
				<xsl:call-template name="recurseChildren">
					<xsl:with-param name="parent" select="." />
						</xsl:call-template>
			</li>
		</xsl:for-each>
	</ul>
	</div>

</xsl:template>
		
	<xsl:template name="recurseChildren">
			<xsl:param name="parent" />
			
			<xsl:if test="count($parent/Categories/CategoryInfo) &gt; 0">
				<ul>
				<xsl:for-each select="$parent/Categories/CategoryInfo">
					<li>
						
						<xsl:choose>
					<xsl:when test="./UIEditor !=''">
						<label class="radio">
							<input type="radio" name="listing-category" class="link category-radio">
							<xsl:attribute name="data-category-path">
								<xsl:value-of select="./Path" />
							</xsl:attribute>
							<xsl:attribute name="data-category-name">
								<xsl:value-of select="./Name" />
							</xsl:attribute>
							<xsl:attribute name="data-category-id">
								<xsl:value-of select="./ID" />
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="./UIEditor ='AutomotiveListing'">AutomotiveListing</xsl:when>
									<xsl:otherwise>GM</xsl:otherwise>
								</xsl:choose>
								<!--<xsl:value-of select="./UIEditor" />-->
							</xsl:attribute>
							
							<xsl:attribute name="id">listing-category-<xsl:value-of select="./ID" /></xsl:attribute>
							
							<xsl:value-of select="./Name" />
								
							</input>
						</label>
							
					</xsl:when>
					<xsl:otherwise>
						
						<a href="#">
							<xsl:value-of select="./Name" />
							<xsl:if test="count(./Categories/CategoryInfo) &gt; 0">
								<span class="todo-actions"><i class="halflings-icon chevron-right"><xsl:text>
									</xsl:text></i>
								</span>
							</xsl:if>
						</a>
						
					</xsl:otherwise>
				</xsl:choose>
					
						
						<!--
					<xsl:if test="./UIEditor != ''">
								
								<input type="radio" name="listing-category" class="link category-radio">
									<xsl:attribute name="data-category-path">
										<xsl:value-of select="./Path" />
									</xsl:attribute>
									<xsl:attribute name="data-category-name">
										<xsl:value-of select="./Name" />
									</xsl:attribute>
									<xsl:attribute name="data-ui-editor">
										<xsl:value-of select="./UIEditor" />
									</xsl:attribute>
									<xsl:attribute name="value">
										<xsl:value-of select="./UIEditor" />
									</xsl:attribute>
									
									<xsl:attribute name="id">listing-category-<xsl:value-of select="./ID" /></xsl:attribute>
							
								</input>
						
								
							</xsl:if>
							
				
					
						<a href="#">
							
							
					<xsl:if test="./UIEditor != ''">
						<xsl:attribute name="class">has-checkbox</xsl:attribute>
					</xsl:if>
							
							<xsl:value-of select="./Name" />
							
							<xsl:if test="count(./Categories/CategoryInfo) &gt; 0">
								<span class="todo-actions"><i class="halflings-icon chevron-right"><xsl:text>
									</xsl:text></i>
								</span>
							</xsl:if>
							
						</a>
						-->
						
						<xsl:call-template name="recurseChildren">
							<xsl:with-param name="parent" select="." />
						</xsl:call-template>
						
					</li>
				</xsl:for-each>
				</ul>
				
			</xsl:if>
			
		</xsl:template>


</xsl:stylesheet>