<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets" 
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">


<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>

<xsl:template match="/">

	<div style="margin-top:10px;">
		<div class="box">
			<a href="javascript:window.history.back();" class="btn btn-primary"><i class="icon-chevron-left">&nbsp;</i> Exit Preview</a>
		</div>

		<!-- ADD PREVIEW DATA HERE -->
		<xsl:call-template name="preview">
			<!-- use 1 for featured listing -->
			<xsl:with-param name="featured">1</xsl:with-param>
			<xsl:with-param name="title">My Ad Title</xsl:with-param>
			<xsl:with-param name="photo">http://placehold.it/320x240/1ABC9C/FFFFFF</xsl:with-param>
			<xsl:with-param name="photo-thumb">http://placehold.it/100x75</xsl:with-param>
			<!-- photo gallery split array: 70x52-thumb|320x240-photo|full-photo,70x52-thumb|320x240-photo|full-photo,... (if null, use 0) -->
			<xsl:with-param name="photo-gallery">
				http://placehold.it/70x52/1ABC9C/FFFFFF|http://placehold.it/320x240/1ABC9C/FFFFFF|http://placehold.it/640x480/1ABC9C/FFFFFF,
				http://placehold.it/70x52/2ECC71/FFFFFF|http://placehold.it/320x240/2ECC71/FFFFFF|http://placehold.it/640x480/2ECC71/FFFFFF,
				http://placehold.it/70x52/3498DB/FFFFFF|http://placehold.it/320x240/3498DB/FFFFFF|http://placehold.it/640x480/3498DB/FFFFFF,
				http://placehold.it/70x52/9B59B6/FFFFFF|http://placehold.it/320x240/9B59B6/FFFFFF|http://placehold.it/640x480/9B59B6/FFFFFF,
				http://placehold.it/70x52/E67E22/FFFFFF|http://placehold.it/320x240/E67E22/FFFFFF|http://placehold.it/640x480/E67E22/FFFFFF,
				http://placehold.it/70x52/E74C3C/FFFFFF|http://placehold.it/320x240/E74C3C/FFFFFF|http://placehold.it/640x480/E74C3C/FFFFFF,
				http://placehold.it/70x52/95A5A6/FFFFFF|http://placehold.it/320x240/95A5A6/FFFFFF|http://placehold.it/640x480/95A5A6/FFFFFF,
				http://placehold.it/70x52/7F8C8D/FFFFFF|http://placehold.it/320x240/7F8C8D/FFFFFF|http://placehold.it/640x480/7F8C8D/FFFFFF,
				http://placehold.it/70x52/34495E/FFFFFF|http://placehold.it/320x240/34495E/FFFFFF|http://placehold.it/640x480/34495E/FFFFFF
			</xsl:with-param>
			<!-- video split array: 70x52-thumb,320x240-photo,video-url (if null, use 0) -->
			<xsl:with-param name="video">
				http://placehold.it/70x52/7F8C8D/FFFFFF,http://placehold.it/320x240/7F8C8D/FFFFFF,http://www.youtube.com/embed/JW5meKfy3fY
			</xsl:with-param>
			<xsl:with-param name="photo-count">9</xsl:with-param>
			<xsl:with-param name="video-count">1</xsl:with-param>
			<!-- Location format: Bell Post Hill,[space]VIC[space]3215 -->
			<xsl:with-param name="loc">Bell Post Hill, VIC 3215</xsl:with-param>
			<xsl:with-param name="price">999</xsl:with-param>
			<xsl:with-param name="body">
				Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
				tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
				quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
				consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
				cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
				proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			</xsl:with-param>
			<!-- meta table arrays: Your Meta Title~key:value|key:value,...,
									Your Meta Title~key:value|key:value,...
			-->
			<xsl:with-param name="meta">
				Ad Meta Title 1~Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value, 
				Ad Meta Title 2~Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value, 
				Ad Meta Title 3~Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value|Meta Key:Meta Value
			</xsl:with-param>
		</xsl:call-template>
		<!-- /ADD PREVIEW DATA HERE -->

		<div class="box">
			<a href="javascript:window.history.back();" class="btn btn-primary"><i class="icon-chevron-left">&nbsp;</i> Exit Preview</a>
		</div>
	</div>

</xsl:template>

<!-- 
============================================================
	SUBTEMPLATES
============================================================
-->

<xsl:template name="preview">
	<xsl:param name="featured" />
	<xsl:param name="title" />
	<xsl:param name="photo" />
	<xsl:param name="photo-thumb" />
	<xsl:param name="photo-gallery" />
	<xsl:param name="video" />
	<xsl:param name="photo-count" />
	<xsl:param name="video-count" />
	<xsl:param name="loc" />
	<xsl:param name="price" />
	<xsl:param name="body" />
	<xsl:param name="meta" />

	<xsl:choose>
		<xsl:when test="$featured = 1">
			
			<div class="box">
				<h2>Preview: Online in search results (Featured)</h2>
			</div>

			<div class="row-fluid">
				<div class="span9">
					<xsl:call-template name="search-listing">
						<xsl:with-param name="featured"><xsl:value-of select="$featured" /></xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="$title" /></xsl:with-param>
						<xsl:with-param name="photo"><xsl:value-of select="$photo-thumb" /></xsl:with-param>
						<xsl:with-param name="photo-count"><xsl:value-of select="$photo-count" /></xsl:with-param>
						<xsl:with-param name="video-count"><xsl:value-of select="$video-count" /></xsl:with-param>
						<xsl:with-param name="body"><xsl:value-of select="$body" /></xsl:with-param>
						<xsl:with-param name="price"><xsl:value-of select="$price" /></xsl:with-param>
						<xsl:with-param name="loc"><xsl:value-of select="$loc" /></xsl:with-param>
					</xsl:call-template>
				</div>
				<div class="span3">
					<xsl:call-template name="featured-listing">
						<xsl:with-param name="title"><xsl:value-of select="$title" /></xsl:with-param>
						<xsl:with-param name="photo"><xsl:value-of select="$photo" /></xsl:with-param>
						<xsl:with-param name="loc"><xsl:value-of select="$loc" /></xsl:with-param>
						<xsl:with-param name="price"><xsl:value-of select="$price" /></xsl:with-param>
					</xsl:call-template>

					<xsl:call-template name="featured-listing-list">
						<xsl:with-param name="title"><xsl:value-of select="$title" /></xsl:with-param>
						<xsl:with-param name="photo"><xsl:value-of select="$photo-thumb" /></xsl:with-param>
						<xsl:with-param name="loc"><xsl:value-of select="$loc" /></xsl:with-param>
						<xsl:with-param name="price"><xsl:value-of select="$price" /></xsl:with-param>
						<xsl:with-param name="meta"><xsl:value-of select="$meta" /></xsl:with-param>
					</xsl:call-template>
				</div>
			</div>
			<br />

		</xsl:when>
		<xsl:otherwise>

			<div class="box">
				<h2>Preview: Online in search results</h2>
			</div>

			<div class="row-fluid">
				<div class="span9">
					<xsl:call-template name="search-listing">
						<xsl:with-param name="featured"><xsl:value-of select="$featured" /></xsl:with-param>
						<xsl:with-param name="title"><xsl:value-of select="$title" /></xsl:with-param>
						<xsl:with-param name="photo"><xsl:value-of select="$photo-thumb" /></xsl:with-param>
						<xsl:with-param name="photo-count"><xsl:value-of select="$photo-thumb" /></xsl:with-param>
						<xsl:with-param name="video-count"><xsl:value-of select="$photo-thumb" /></xsl:with-param>
						<xsl:with-param name="body"><xsl:value-of select="$body" /></xsl:with-param>
						<xsl:with-param name="price"><xsl:value-of select="$price" /></xsl:with-param>
						<xsl:with-param name="loc"><xsl:value-of select="$loc" /></xsl:with-param>
					</xsl:call-template>
				</div>
				<div class="span3">
					&nbsp;
				</div>
			</div>
			<br />
			
		</xsl:otherwise>
	</xsl:choose>

	<div class="box">
		<h2>Preview: Online ad details page</h2>
	</div>
	<xsl:call-template name="ads-details">
		<xsl:with-param name="title"><xsl:value-of select="$title" /></xsl:with-param>
		<xsl:with-param name="photo-gallery"><xsl:value-of select="$photo-gallery" /></xsl:with-param>
		<xsl:with-param name="video"><xsl:value-of select="$video" /></xsl:with-param>
		<xsl:with-param name="loc"><xsl:value-of select="$loc" /></xsl:with-param>
		<xsl:with-param name="price"><xsl:value-of select="$price" /></xsl:with-param>
		<xsl:with-param name="body"><xsl:value-of select="$body" /></xsl:with-param>
		<xsl:with-param name="meta"><xsl:value-of select="$meta" /></xsl:with-param>
	</xsl:call-template>
	<br />
	
</xsl:template>

<xsl:template name="search-listing">
	<xsl:param name="featured" />
	<xsl:param name="title" />
	<xsl:param name="photo" />
	<xsl:param name="photo-count" />
	<xsl:param name="video-count" />
	<xsl:param name="body" />
	<xsl:param name="price" />
	<xsl:param name="loc" />
	<div class="search-listing" style="margin-top:0">
		<form>
			<header class="hidden-phone">
				<div class="col compare"><div style="width:85px;height:28px">&nbsp;</div></div>
				<div class="col item"><a href="#">Item</a></div>
				<div class="col location"><a href="#">Location</a></div>
				<div class="col price"><a href="#">Price</a></div>
			</header>

			<div>
				<xsl:choose>
					<xsl:when test="$featured = 1">
						<xsl:attribute name="class">search-item feature</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">search-item</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
				<div class="col compare hidden-phone">
					&nbsp;
				</div>
				<a href="#" class="search-item-link">
					<div class="col image">
						<img alt="">
							<xsl:attribute name="src">
								<xsl:value-of select="$photo" />
							</xsl:attribute>
						</img>
						<xsl:if test="$photo-count > 0">
							<div class="photo-info"><i class="tp-sprite-images">&nbsp;</i> <xsl:value-of select="$photo-count" /> Photos</div>
						</xsl:if>
						<xsl:if test="$video-count > 0">
							<div class="photo-video"><i class="tp-sprite-video">&nbsp;</i> <xsl:value-of select="$video-count" /> Video</div>
						</xsl:if>
					</div>
					<div class="col item">
						<h3><i class="tp-sprite-newad">&nbsp;</i>&nbsp;<xsl:value-of select="$title" /></h3>
						<p><xsl:value-of select="umbraco.library:TruncateString($body,250,'...')" /></p>
					</div>
					<div class="col location">
						<xsl:variable name="si-loc" select="umbraco.library:Split($loc,',')" />
						<xsl:variable name="si-loc-2" select="umbraco.library:Split(normalize-space($si-loc/value[2]),' ')" />
						<xsl:value-of select="normalize-space($si-loc-2/value[1])" />
					</div>
					<div class="col price">
						$<xsl:value-of select="$price" />
					</div>
					<div class="btn btn-primary">View ad <i class="tp-sprite-arrow-right-white">&nbsp;</i></div>
				</a>
			</div><!-- search-item -->

		</form>
	
	</div> <!-- /search-listing -->
</xsl:template>

<xsl:template name="featured-listing">
	<xsl:param name="title" />
	<xsl:param name="photo" />
	<xsl:param name="loc" />
	<xsl:param name="price" />

	<div id="tssidebar">
	<div class="flexslider top-spot-container">
		<h2>TOP ADS</h2>
		<nav>
			<span class="btn btn-primary btn-small" id="nav-prev"><i class="icon icon-white icon-backward"><xsl:text>
			</xsl:text></i></span>
			<span class="btn btn-primary btn-small" id="nav-next"><i class="icon icon-white icon-forward"><xsl:text>
			</xsl:text></i></span>
		</nav>
		<ul id="top-spot" class="slides">
			<li>
				<figure>
					<div class="thumb">
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="$photo" />
							</xsl:attribute>
							<xsl:attribute name="title">
								<xsl:value-of select="$title" />
							</xsl:attribute>
						</img>
						<div class="meta-location">
							<xsl:variable name="si-loc" select="umbraco.library:Split($loc,',')" />
							<xsl:variable name="si-loc-2" select="umbraco.library:Split(normalize-space($si-loc/value[2]),' ')" />
							Now @ <xsl:value-of select="normalize-space($si-loc-2/value[1])" />
						</div>
						<div class="meta-price">
							$<xsl:value-of select="$price" />
						</div>
					</div>
					<figcaption>
						<a href="#">
							<xsl:value-of select="$title" />
						</a>
					</figcaption>
				</figure>
			</li>
		</ul>
	</div>
	</div>
</xsl:template>

<xsl:template name="featured-listing-list">
	<xsl:param name="title" />
	<xsl:param name="photo" />
	<xsl:param name="loc" />
	<xsl:param name="price" />
	<xsl:param name="meta" />

	<!-- ads-featured -->
	<div class="ads-featured hidden-phone">
		<ul>
			<li>
				<a href="#">
					<div class="image">
						<img>
							<xsl:attribute name="src">
								<xsl:value-of select="$photo" />
							</xsl:attribute>
						</img>
					</div>
					<div class="item">
						<h3><xsl:value-of select="$title" /></h3>
					</div>
					<div class="location">
						<xsl:variable name="si-loc" select="umbraco.library:Split($loc,',')" />
						<xsl:variable name="si-loc-2" select="umbraco.library:Split(normalize-space($si-loc/value[2]),' ')" />
						<xsl:value-of select="normalize-space($si-loc-2/value[1])" />
					</div>
					<div class="price">
						$<xsl:value-of select="$price" />
					</div>
				</a>
			</li>
		</ul>
	</div>
	<!-- /ads-featured -->
</xsl:template>

<xsl:template name="ads-details">
	<xsl:param name="title" />
	<xsl:param name="photo-gallery" />
	<xsl:param name="video" />
	<xsl:param name="loc" />
	<xsl:param name="price" />
	<xsl:param name="body" />
	<xsl:param name="meta" />

	<h2 class="box-header box-header-primary push-top">
		<div class="ad-title left normal border-right"><xsl:value-of select="$title" /></div>
		<div class="ad-price left">Price:  $<xsl:value-of select="$price" /></div>
		<div class="ad-location right"><xsl:value-of select="$loc" /></div>
	</h2>

	<div class="row-fluid">
		<div class="span8">

			<div class="ad-images">

				<div class="flexslider">
					<ul class="slides">
						<xsl:if test="$video != 0">
							<xsl:variable name="v" select="umbraco.library:Split($video,',')" />
							<li data-modal-content="video">
								<xsl:attribute name="data-thumb"><xsl:value-of select="normalize-space($v/value[1])" /></xsl:attribute>
								<a target="_blank">
									<xsl:attribute name="href"><xsl:value-of select="normalize-space($v/value[3])" /></xsl:attribute>
									<img alt="" itemprop="image">
										<xsl:attribute name="src"><xsl:value-of select="normalize-space($v/value[2])" /></xsl:attribute>
									</img>
								</a>
							</li>
						</xsl:if>
						<xsl:if test="$photo-gallery != 0">
							<xsl:variable name="pg" select="umbraco.library:Split($photo-gallery,',')" />
							<xsl:for-each select="$pg/value">
								<xsl:variable name="p" select="umbraco.library:Split(.,'|')" />
									<li>
										<xsl:attribute name="data-thumb"><xsl:value-of select="normalize-space($p/value[1])" /></xsl:attribute>
										<a target="_blank">
											<xsl:attribute name="href"><xsl:value-of select="normalize-space($p/value[3])" /></xsl:attribute>
											<img alt="" itemprop="image">
												<xsl:attribute name="src"><xsl:value-of select="normalize-space($p/value[2])" /></xsl:attribute>
											</img>
										</a>
									</li>
							</xsl:for-each>
						</xsl:if>
					</ul>
					<div class="enlarge">Enlarge</div>
				</div>
			</div>
			<!-- /ad-images -->

			<div class="ad-description">

				<div class="visible-phone" style="margin-bottom:10px;">
					<a href="#email" class="btn btn-primary btn-block">Contact Seller</a>
				</div>

				<h3>Description</h3>
				<p>
					<xsl:value-of select="$body" />
				</p>
				<a href="#more-ad-details" class="show-hide-mobile btn btn-info visible-phone">Show more details</a>
			</div>


			<div id="more-ad-details" class="hidden-phone">

				<xsl:for-each select="umbraco.library:Split($meta,',')/value">
				<div class="ad-meta-list">
						<xsl:variable name="mt" select="umbraco.library:Split(.,'~')" />
						<xsl:variable name="mt-title" select="$mt/value[1]" />
						<xsl:variable name="mt-content" select="$mt/value[2]" />
						<h3><xsl:value-of select="$mt-title" /></h3>
						<dl>
						<xsl:for-each select="umbraco.library:Split($mt-content,'|')/value">
							<xsl:for-each select="umbraco.library:Split(.,':')">
									<dt><xsl:value-of select="normalize-space(./value[1])" /></dt>
									<dd><xsl:value-of select="normalize-space(./value[2])" /></dd>
							</xsl:for-each>	
						</xsl:for-each>
						</dl>
				</div>
				</xsl:for-each>

				<div class="push-top visible-phone"><xsl:text>
				</xsl:text></div>
				
			</div>

		</div><!-- /span8 (Left Side) -->
		<div class="span4">

			<div id="email" class="box box-border box-important ad-email">
				<h2>Email seller</h2>
				<form>
					<table>
						<tr>
							<td style="width:80px;"><label for="inputName"><span class="important">*</span> Name</label></td>
							<td><input type="text" id="inputName" name="buyer-name" class="input-block-level" /></td>
						</tr>
						<tr>
							<td><label for="inputLocation"><span class="important">*</span> Location</label></td>
							<td><input type="text" id="inputLocation" name="buyer-loc" class="input-block-level" placeholder="Suburb, Postcode, State" /></td>
						</tr>
						<tr>
							<td><label for="inputPhone"><span class="important">*</span> Phone</label></td>
							<td><input type="text" id="inputPhone" name="buyer-phone" class="input-block-level" placeholder="eg.039xxxxxxx or 0409xxxxxx" /></td>
						</tr>
						<tr>
							<td><label for="inputEmail"><span class="important">*</span> Email</label></td>
							<td><input type="text" id="inputEmail" name="buyer-email" class="input-block-level" placeholder="Email" /></td>
						</tr>
						<tr>
							<td colspan="2">
								<div class="box-seperator">&nbsp;</div>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label for="inputMessage"><span class="important">*</span> Message</label>
								<textarea id="inputMessage" name="buyer-message" class="input-block-level" rows="4" placeholder="Enter your message here (Max 255 characters)"><xsl:text>
									</xsl:text></textarea>
							</td>
						</tr>
					</table>
					<footer>
						<button type="submit" name="submit" value="contact-seller" class="btn btn-primary pull-left">Send <i class="icon-chevron-right"><xsl:text>
							</xsl:text></i></button>
						Our <a href="#">Privacy Policy</a> applies
					</footer>
				</form>
			</div><!-- /ad-email -->

			<div class="box box-border ad-tools">
				<h2>Tools</h2>
				<i class="tp-sprite-add">&nbsp;</i> <a href="#">Add to Items of Interest</a><br />
				<i class="tp-sprite-fav">&nbsp;</i> <a href="#">Add seller to favourites</a><br />
				<i class="tp-sprite-email2">&nbsp;</i> <a href="#">Email to a friend</a><br />
				<i class="tp-sprite-sms">&nbsp;</i> <a href="#">SMS alert</a><br />
				<i class="tp-sprite-print">&nbsp;</i> <a href="#">Print this page</a>
			</div><!-- /ad-tools -->

		</div><!-- /span4 (Right Side) -->
	</div>
	
</xsl:template>

</xsl:stylesheet>