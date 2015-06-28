<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#x00A0;"> ]>
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxml="urn:schemas-microsoft-com:xslt"
  xmlns:scripts="urn:scripts.this"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:easylist="urn:http://easylist.com.au/api"
  xmlns:umbraco.library="urn:umbraco.library" xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon" xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes" xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath" xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions" xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings" xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  exclude-result-prefixes="msxml easylist scripts umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ">

<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
<xsl:include href="EasyListEditAPIHelper.xslt" />

    <xsl:variable name="userName" select="umbraco.library:Session('easylist-username')" />
    <xsl:variable name="password" select="umbraco.library:Session('easylist-password')" />
    <xsl:variable name="listingCode" select="/macro/listingCode" />
    
<xsl:param name="currentPage"/>

<xsl:template match="/">
  
  <xsl:choose>
    <xsl:when test="string-length(umbraco.library:RequestForm('update-listing')) &gt; 0">
      <!-- Update Listing Clicked -->
      <xsl:variable name="updateResponse" select="scripts:UpdateListing()" />
      <!--
      <textarea>
        <xsl:copy-of select="$updateResponse" />
      </textarea>
      -->
      <xsl:call-template name="listingEditor" />
    </xsl:when>
    
    <xsl:when test="string-length(umbraco.library:RequestForm('update-photos')) &gt; 0">
      <!-- Modify Images Clicked -->
      <xsl:variable name="modifyResponse" select="scripts:ModifyListingImages()" />
      <!--
      <textarea>
        <xsl:copy-of select="$modifyResponse" />
      </textarea>
      -->
      <xsl:call-template name="listingEditor" />
    </xsl:when>
    
    <xsl:when test="string-length(umbraco.library:RequestForm('update-features')) &gt; 0">
      <!-- Modify Features Clicked -->
      <xsl:variable name="modifyResponse" select="scripts:ModifyAutoFeatures()" />
      <!--
      <textarea>
        <xsl:copy-of select="$modifyResponse" />
      </textarea>
      -->
      <xsl:call-template name="listingEditor" />
    </xsl:when>
    
    <xsl:when test="string-length(umbraco.library:RequestForm('add-video')) &gt; 0">
      <!-- Add Video Clicked (Note: this form data comes from the lightbox popup,
           which comes from AddYouTubeVideo.xslt) -->
      <xsl:variable name="addVideoResponse" select="scripts:AddListingVideo()" />
      <!--
      <textarea>
        <xsl:copy-of select="$addVideoResponse" />
      </textarea>
      -->
      <xsl:call-template name="listingEditor" />
    </xsl:when>
    
    <xsl:when test="string-length(umbraco.library:RequestForm('delete-video')) &gt; 0">
      <!-- Delete Video Clicked -->
      <xsl:variable name="deleteVideoResponse" select="scripts:DeleteListingVideo()" />
      <!--
      <textarea>
        <xsl:copy-of select="$deleteVideoResponse" />
      </textarea>
      -->
      <xsl:call-template name="listingEditor" />
    </xsl:when>
    
    <xsl:otherwise>
      <!-- No form submitted, so just render the output -->
      <xsl:call-template name="listingEditor" />
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>
    

<xsl:template name="listingEditor">
  
      <!-- Get the listing edit data and render the form -->
      <xsl:variable name="data" select="scripts:GetListingEditData($userName, $password, $listingCode)" />
      <xsl:variable name="dataType" select="name($data/*)" />
    
      <!-- debugging -->
      <!--
      <textarea>
        <xsl:copy-of select="$data"  />
      </textarea>
      -->
      
      <!-- Render based on data type -->
      <xsl:choose>
        <xsl:when test="$dataType ='error'">
          An error ocurred.
        </xsl:when>
        <xsl:when test="$dataType = 'MotorcycleListingEditInfo'">
          <xsl:call-template name="motorcycle">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$dataType = 'AutomotiveListingEditInfo'">
          <xsl:call-template name="automotive">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gm">
            <xsl:with-param name="data" select="$data/*" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

    
<!-- GM Edit Template -->    
    
    
<xsl:template name="gm">
  <xsl:param name="data" />

  <div class="form-builder">

      <!-- Listing Details -->
      <div id="edit-listing" class="ajax" data-url="/ajax/edit-listing.aspx?listing={$data/Code}">
        <xsl:call-template name="gmDetails">
          <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Images -->
      <div id="manage-images" class="ajax" data-url="/ajax/manage-photos.aspx?listing={$data/Code}">
        <xsl:call-template name="listingImages">
           <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Videos-->
      <div id="manage-videos" class="ajax" data-url="/ajax/manage-videos.aspx?listing={$data/Code}">
      <xsl:call-template name="listingVideos">
         <xsl:with-param name="data" select="$data" />
      </xsl:call-template>
      </div>
    
  </div>
  
</xsl:template>
          
<xsl:template name="gmDetails">
  <xsl:param name="data" />
  
  <xsl:variable name="showFieldLocks" select="$data/SourceName !=''" />
  
  <form method="post" id="listing-details-form">
    
    <div class="group-box">
      <div class="underlay">
        <h1><span class="details">&nbsp;</span>Listing Details <input class="button save update-listing" type="submit" id="update-listing" value="Update Listing Details" /></h1>
      </div>
      <ul class="full">
        <li>
          <label>Title</label>
          <input class="text allow-lowercase" type="text" maxlength="100" name="listing-title" value="{$data/Title}">
            <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 100, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
          </input>
          <xsl:if test="$showFieldLocks = '1'">
            <input type="checkbox" name="lock-title" value="true" class="lock-field">
              <xsl:if test="$data/LockTitle ='true'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
          </xsl:if>
        </li>
      </ul>
      <ul class="left half">
        <li>&nbsp;</li>
      </ul>
      
      <ul class="right half">
          <!-- Render the standard listing fields -->
          <xsl:call-template name="standardfields">
            <xsl:with-param name="data" select="$data" />
            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
          </xsl:call-template>
        </ul>
      </div>
      
      <!-- Description Editors -->
      <xsl:call-template name="descriptionEditors">
        <xsl:with-param name="data" select="$data" />
        <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
      </xsl:call-template>
      
      <input type="hidden" name="listing-code" value="{$data/Code}" />
      <input type="hidden" name="listing-type" value="gm" />
      <input type="hidden" name="update-listing" value="true" />
      
    </form>

</xsl:template>
    
    
<!-- Motorcycle Edit Template -->   
    
    
<xsl:template name="motorcycle">
  <xsl:param name="data" />
  
  <div class="form-builder">
   
      <!-- Listing Details -->
      <div id="edit-listing" class="ajax" data-url="/ajax/edit-listing.aspx?listing={$data/Code}">
        <xsl:call-template name="motorcycleDetails">
          <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Images -->
      <div id="manage-images" class="ajax" data-url="/ajax/manage-photos.aspx?listing={$data/Code}">
        <xsl:call-template name="listingImages">
           <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Videos-->
      <div id="manage-videos" class="ajax" data-url="/ajax/manage-videos.aspx?listing={$data/Code}">
      <xsl:call-template name="listingVideos">
         <xsl:with-param name="data" select="$data" />
      </xsl:call-template>
      </div>
    
  </div>
</xsl:template>
    
<xsl:template name="motorcycleDetails">
  <xsl:param name="data" />
  
  <xsl:variable name="showFieldLocks" select="$data/SourceName !=''" />
  

   <form method="post" id="listing-details-form">
      
      <div class="group-box">
        <div class="underlay">
        <h1><span class="details">&nbsp;</span>Listing Details <input class="button save update-listing" type="submit" id="update-listing" value="Update Listing Details" /></h1>
        </div>
          <ul class="full">
          <li>
            <label>Title</label>
            <input class="text allow-lowercase" type="text" maxlength="100" name="listing-title" value="{$data/Title}">
              <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 100, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-title" value="true" class="lock-field">
                <xsl:if test="$data/LockTitle ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
        </ul>
        <ul class="left half">
          <li>
            <label>Make</label>
            <input class="text disabled" type="text" disabled="disabled" maxlength="100" name="listing-make" value="{$data/Make}" />
          </li>
          <li>
            <label>Model</label>
            <input class="text disabled" type="text" disabled="disabled" maxlength="100" name="listing-model" value="{$data/Model}" />
          </li>
          <li>
            <label>Year</label>
            <input class="text disabled year" type="text" disabled="disabled" maxlength="4" name="listing-year" value="{$data/Year}" />
          </li>
          <li>
            <label>Transmission</label>
            <input class="text" type="text" maxlength="50" name="listing-transmission" value="{$data/Transmission}">
              <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
                <input type="checkbox" name="lock-transmission" value="true" class="lock-field">
                  <xsl:if test="$data/LockTransmission ='true'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
            </xsl:if>
          </li>
          <li>
            <label>Colour</label>
            <input class="text" type="text" maxlength="50" name="listing-exterior-colour" value="{$data/ExteriorColour}">
              <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-exterior-colour" value="true" class="lock-field">
                <xsl:if test="$data/LockExteriorColour ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          <li>
            <label>No. of gears</label>
            <input class="text integer" type="text" maxlength="50" name="listing-gears"  value="{$data/Gears}">
              <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-gears" value="true" class="lock-field">
                <xsl:if test="$data/LockGears ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>   
          <li>
            <label>Engine CC's</label>
            <input class="text integer" type="text" maxlength="50" name="listing-engine"  value="{$data/Engine}">
              <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-engine" value="true" class="lock-field">
                <xsl:if test="$data/LockEngine ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          <li>
            <label>No. of cylinders</label>
            <input class="text integer" type="text" maxlength="50" name="listing-cylinders" value="{$data/Cylinders}">
              <xsl:attribute name="data-validate">{required: false, maxlength: 50}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-cylinders" id="lock-cylinders" value="true" class="lock-field">
                <xsl:if test="$data/LockCylinders ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
        </ul>
        <ul class="right half">
          <!-- Render the standard listing fields -->
          <xsl:call-template name="standardfields">
            <xsl:with-param name="data" select="$data" />
            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
          </xsl:call-template>
        </ul>
      </div>
      
      <!-- Description Editors -->
      <xsl:call-template name="descriptionEditors">
        <xsl:with-param name="data" select="$data" />
        <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
      </xsl:call-template>
      
      <input type="hidden" name="listing-code" value="{$data/Code}" />
      <input type="hidden" name="listing-type" value="motorcycle" />
      <input type="hidden" name="update-listing" value="true" />
      
    </form>
  
</xsl:template>
    
    
<!-- Auto Edit Template -->   
    
    
<xsl:template name="automotive">
  <xsl:param name="data" />
  
  <div class="form-builder">

      <!-- Listing Details -->
      <div id="edit-listing" class="ajax" data-url="/ajax/edit-listing.aspx?listing={$data/Code}">
        <xsl:call-template name="autoDetails">
          <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>

      <!-- Vehicle Features -->
      <div id="edit-features" class="ajax" data-url="/ajax/edit-features.aspx?listing={$data/Code}">
        <xsl:call-template name="featureEditors">
           <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Images -->
      <div id="manage-images" class="ajax" data-url="/ajax/manage-photos.aspx?listing={$data/Code}">
        <xsl:call-template name="listingImages">
           <xsl:with-param name="data" select="$data" />
        </xsl:call-template>
      </div>
    
      <!-- Listing Videos-->
      <div id="manage-videos" class="ajax" data-url="/ajax/manage-videos.aspx?listing={$data/Code}">
      <xsl:call-template name="listingVideos">
         <xsl:with-param name="data" select="$data" />
      </xsl:call-template>
      </div>

  </div>
  
</xsl:template>
    
<xsl:template name="autoDetails">
  <xsl:param name="data" />
  
  <xsl:variable name="showFieldLocks" select="$data/SourceName !=''" />
 
    <form method="post" id="listing-details-form">
      
      <div class="group-box">
        <div class="underlay">
        <h1><span class="details">&nbsp;</span>Listing Details <input class="button save update-listing" type="submit" id="update-listing" value="Update Listing Details" /></h1>
        </div>
          <ul class="full">
          <li>
            <label>Title</label>
            <input class="text allow-lowercase" type="text" maxlength="100" name="listing-title" value="{$data/Title}">
              <xsl:attribute name="data-validate">{required: true, minlength: 3, maxlength: 100, messages: {required: 'Please enter the listing title'}}</xsl:attribute>
            </input>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-title" value="true" class="lock-field">
                <xsl:if test="$data/LockTitle ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
        </ul>
        <ul class="left half">
          
            <li>
              <label>Make</label>
              <input class="text" type="text" disabled="disabled" maxlength="100" name="listing-make" value="{$data/Make}" />
            </li>
            <li>
              <label>Model</label>
              <input class="text" type="text" disabled="disabled" maxlength="100" name="listing-model" value="{$data/Model}" />
            </li>
            <xsl:if test="$data/Series !=''">
              <li>
                <label>Series</label>
                <input class="text" type="text" disabled="disabled" maxlength="100" name="listing-series" value="{$data/Series}" />
              </li>
            </xsl:if>
            <xsl:if test="$data/Variant !=''">
              <li>
                <label>Badge</label>
                <input class="text" type="text" disabled="disabled" maxlength="100" name="listing-variant" value="{$data/Variant}" />
              </li>
            </xsl:if>
            <li>
              <label>Year</label>
              <input class="text year" type="text" disabled="disabled" maxlength="4" name="listing-year" value="{$data/Year}" />
          </li>
          
          <li>
            <label>Body Type</label>
            <select class="drop-down" name="listing-body-style">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,4x4,Covertible,Coupe,Hatchback,People Mover,SUV,Sedan,Sports,Truck/Bus,Ute,Van,Wagon</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/BodyStyle" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-body-style" value="true" class="lock-field">
                <xsl:if test="$data/LockBodyStyle ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          <li>
            <label>No. of doors</label>
            <input class="text integer" type="text" maxlength="4" name="listing-doors" value="{$data/Doors}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-doors" value="true" class="lock-field">
                <xsl:if test="$data/LockDoors ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          <li>
            <label>Number of seats</label>
            <input type="text" maxlength="4" name="listing-seats" class="text integer" value="{$data/Seats}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-seats" value="true" class="lock-field">
                <xsl:if test="$data/LockSeats ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
 
          <li>
            <label>Body Description</label>
            <input class="text" type="text" maxlength="100" name="listing-body-style-description" value="{$data/BodyStyleDescription}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-body-style-description" value="true" class="lock-field">
                <xsl:if test="$data/LockBodyStyleDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Exterior Colour</label>
            <input class="text" type="text" maxlength="100" name="listing-exterior-colour" value="{$data/ExteriorColour}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-exterior-colour" value="true" class="lock-field">
                <xsl:if test="$data/LockExteriorColour ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          <li>
            <label>Interior Colour</label>
            <input class="text" type="text" maxlength="100" name="listing-interior-colour" value="{$data/InteriorColour}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-interior-colour" value="true" class="lock-field">
                <xsl:if test="$data/LockInteriorColour ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Odometer</label>
            <input type="text" maxlength="9" name="listing-odometer-value" class="text integer inline" value="{$data/Odometer}" />
            <select class="drop-down inline" name="listing-odometer-unit">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,KM,MI</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/OdometerUnit" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-odometer" value="true" class="lock-field">
                <xsl:if test="$data/LockOdometer ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Registration</label>
            <input type="text" maxlength="20" name="listing-registration-number" value="{$data/RegistrationNumber}" class="text inline" />
            <select name="listing-registration-type" class="drop-down inline">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,Registration number,Stock number,VIN</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/RegistrationType" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-registration" value="true" class="lock-field">
                <xsl:if test="$data/LockRegistrationNumberType ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Drive Type</label>
            <select class="drop-down" name="listing-drive-type">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,4x2,4x4,4WD,AWD,FWD,RWD</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/DriveTypeDescription" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-drive-type" value="true" class="lock-field">
                <xsl:if test="$data/LockDriveTypeDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>

          </ul>

        <ul class="right half">
          
          <!-- Render the standard listing fields -->
          <xsl:call-template name="standardfields">
            <xsl:with-param name="data" select="$data" />
            <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
          </xsl:call-template>

          <li>
            <label>Transmission</label>
            <input class="text" type="text" maxlength="20" name="listing-transmission-description" value="{$data/TransmissionDescription}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-transmission-description" value="true" class="lock-field">
                <xsl:if test="$data/LockTransmissionDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Engine Type</label>
            <select class="drop-down" name="listing-engine-type-description">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,CARB,DIESEL,DIESEL FUEL INJECTED,DIESEL MPFI,DIESEL TURBO,DIESEL TURBO F/INJ,ELECTRONIC F/INJ,FUEL INJECTED,LPG,MILLER CYCLE,MULTI POINT F/INJ,S/C &amp; T/C MPFI,SINGLE POINT F/INJ,SUPERCHARGED MPFI,TURBO CDI,TURBO EFI,TURBO MPFI,TWIN CARB,TWIN TURBO MPFI</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/EngineDescription" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-engine-type-description" value="true" class="lock-field">
                <xsl:if test="$data/LockEngineDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>

          <li>
            <label>Engine Cylinders</label>
            <input class="text" type="text" maxlength="20" name="listing-engine-cylinders" value="{$data/EngineCylinders}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-engine-cylinders" value="true" class="lock-field">
                <xsl:if test="$data/LockEngineCylinders ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
            
          <li>
            <label>Engine Size</label>
            <input class="text" type="text" maxlength="20" name="listing-engine-size-description" value="{$data/EngineSizeDescription}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-engine-size-description" value="true" class="lock-field">
                <xsl:if test="$data/LockEngineSizeDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
            
          <li>
            <label>Fuel Type</label>
            <select class="drop-down" name="listing-fuel-type-description">
              <xsl:call-template name="optionlist">
                <xsl:with-param name="options">,DIESEL,LEADED PETROL,LIQUID PETROLEUM GAS,PETROL,Petrol &amp; Gas,Petrol &amp; LPG,Petrol or LPG (Dual),PREMIUM UNLEADED PETROL,UNLEADED PETROL</xsl:with-param>
                <xsl:with-param name="value">
                  <xsl:value-of select="$data/FuelTypeDescription" />
                </xsl:with-param>
              </xsl:call-template>
            </select>
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-fuel-type-description" value="true" class="lock-field">
                <xsl:if test="$data/LockFuelTypeDescription ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
          
          <li>
            <label>Transmission Type</label>
            <input class="text" type="text" maxlength="20" name="listing-transmission-type" value="{$data/TransmissionType}" />
            <xsl:if test="$showFieldLocks = '1'">
              <input type="checkbox" name="lock-transmission-type" value="true" class="lock-field">
                <xsl:if test="$data/LockTransmissionType ='true'">
                  <xsl:attribute name="checked">checked</xsl:attribute>
                </xsl:if>
              </input>
            </xsl:if>
          </li>
    
        </ul>
      </div>
      
      <!-- Description Editors -->
      <xsl:call-template name="descriptionEditors">
        <xsl:with-param name="data" select="$data" />
        <xsl:with-param name="showFieldLocks" select="$showFieldLocks" />
      </xsl:call-template>
      
      <input type="hidden" name="listing-code" value="{$data/Code}" />
      <input type="hidden" name="listing-type" value="auto" />
      <input type="hidden" name="update-listing" value="true" />
      
      </form>
  
</xsl:template>
    
    
<!-- Standard Listing Fields -->  

    
<xsl:template name="standardfields">
  <xsl:param name="data" />
  <xsl:param name="showFieldLocks" />
   
    <li>
      <label>Price</label>
      <input class="text money" type="text" maxlength="10" name="listing-price" value="{scripts:FormatPrice($data/Price)}">
        <xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
      </input>
      
      <xsl:if test="$showFieldLocks = '1'">
        <input type="checkbox" name="lock-price" value="true" class="lock-field">
          <xsl:if test="$data/LockPrice ='true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </xsl:if>
    </li>
    <li>
      <label>Was Price</label>
      <input class="text money" type="text" maxlength="10" name="listing-was-price" value="{scripts:FormatPrice($data/WasPrice)}">
        <xsl:attribute name="data-validate">{required: false, regex:/^\$?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}[0-9]{0,}(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/, messages: {regex: 'The amount entered is invalid'}}</xsl:attribute>
      </input>
      <xsl:if test="$showFieldLocks = '1'">
        <input type="checkbox" name="lock-was-price" value="true" class="lock-field">
          <xsl:if test="$data/LockWasPrice ='true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </xsl:if>
    </li>
    <li>
      <label>Price Description</label>
      <select class="drop-down" name="listing-price-qualifier">
        <xsl:call-template name="optionlist">
          <xsl:with-param name="options">,Call for Price,Drive Away,External Auction</xsl:with-param>
          <xsl:with-param name="value">
            <xsl:value-of select="$data/PriceQualifier" />
          </xsl:with-param>
        </xsl:call-template>
      </select>
      <xsl:if test="$showFieldLocks = '1'">
        <input type="checkbox" name="lock-price-qualifier" value="true" class="lock-field">
          <xsl:if test="$data/LockPriceQualifier ='true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </xsl:if>
    </li>
    <li>
      <label>Condition</label>
      <select class="drop-down" name="listing-condition">
        <xsl:call-template name="optionlist">
          <xsl:with-param name="options">New,Used,Demo</xsl:with-param>
          <xsl:with-param name="value">
            <xsl:value-of select="$data/Condition" />
          </xsl:with-param>
        </xsl:call-template>
      </select>
      <xsl:if test="$showFieldLocks = '1'">
        <input type="checkbox" name="lock-condition" value="true" class="lock-field">
          <xsl:if test="$data/LockCondition ='true'">
            <xsl:attribute name="checked">checked</xsl:attribute>
          </xsl:if>
        </input>
      </xsl:if>
    </li>  
  
    <li>
      <label>Show on website</label>
      <input type="checkbox" name="listing-publish" value="true">
        <xsl:if test="$data/IsHidden = 'false'">
          <xsl:attribute name="checked">checked</xsl:attribute>
        </xsl:if>
      </input>
    </li>
  
    <li>
      <label>Date Created</label>
      <label class="value">
        <xsl:value-of select="umbraco.library:FormatDateTime($data/PublishDate, 'd MMM yyyy, HH:mm')" />
      </label>
    </li>
  
    <li>
      <label>Last Edited</label>
      <label class="value">
        <xsl:choose>
          <xsl:when test="$data/LastEdited !=''">
            <xsl:value-of select="umbraco.library:FormatDateTime($data/LastEdited, 'd MMM yyyy, HH:mm')" />
          </xsl:when>
          <xsl:otherwise><i>(Never)</i></xsl:otherwise>
        </xsl:choose>
      </label>
    </li>
  
    <li>
      <label>Data Source</label>
      <label class="value">
        <xsl:choose>
          <xsl:when test="$data/ExternalLink != ''">
            <a href="{$data/ExternalLink}" target="_blank">
              <xsl:value-of select="$data/SourceName" />
            </a>
          </xsl:when>
          <xsl:otherwise><i>N/A</i></xsl:otherwise>
        </xsl:choose>
      </label>
    </li>
  
  
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
    
    
<!-- Summary and full description editors -->
 
    
<xsl:template name="descriptionEditors">
  <xsl:param name="data" />
  <xsl:param name="showFieldLocks" />
  
      <div class="group-box">
        <div class="underlay">
          <h1><span class="description">&nbsp;</span>Comments/Description <input class="button save update-listing" type="submit" name="update-listing" value="Update Description/Comments" /></h1>
        </div>
        <ul class="full">
            <li>
              <label class="on-top">Summary Description <span>(Displayed in search results)</span></label>
              <textarea name="listing-summary" class="summary">
                <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 250, messages: {required: 'Please enter a short summary description for display in search results'}}</xsl:attribute>
                <xsl:value-of select="$data/SummaryDescription" />
              </textarea>
              <xsl:if test="$showFieldLocks = '1'">
                <input type="checkbox" name="lock-summary-description" value="true" class="lock-field">
                  <xsl:if test="$data/LockSummaryDescription ='true'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
              </xsl:if>
            </li>
            <li>
              <label class="on-top">Full Description <span>(Displayed on the details screen)</span></label>
              <textarea name="listing-description" class="summary"><!-- class="wysiwyg" -->
                <xsl:attribute name="data-validate">{required: true, minlength: 6, maxlength: 5000, messages: {required: 'Please enter a detailed description for display on the item details page'}}</xsl:attribute>
                <xsl:value-of select="$data/Description" />
              </textarea>
              <xsl:if test="$showFieldLocks = '1'">
                <input type="checkbox" name="lock-description" value="true" class="lock-field">
                  <xsl:if test="$data/LockDescription ='true'">
                    <xsl:attribute name="checked">checked</xsl:attribute>
                  </xsl:if>
                </input>
              </xsl:if>
            </li>
        </ul>
      </div>
  
</xsl:template>

    
<!-- Automotive feature editors -->
    
    
<xsl:template name="featureEditors">
  <xsl:param name="data" />
  <xsl:param name="showFieldLocks" />

  <form method="post" id="edit-features-form">
    <div class="group-box">
      <div class="underlay">
        <h1><span class="features">&nbsp;</span>Vehicle Features <input class="button save" type="submit" name="update-features" id="update-features" value="Update Listing Features" /></h1>
      </div>
      
      <fieldset class="left half">
        
        <h3>Standard Features</h3>
        
        <ul class="select-list" id="standard-features">
          <xsl:for-each select="$data/Features/AutomotiveFeatureEditInfo">
            <xsl:if test="./FeatureType = 'standard'">
              <li data-id="{./ID}">
                <span>
                  <xsl:value-of select="./FeatureDescription" />
                </span>
                <a href="#" class="select-item-delete" data-id="{./ID}">Delete</a>
              </li>
            </xsl:if>
          </xsl:for-each>
        <xsl:text>
        </xsl:text></ul>
        
        <input type="text" id="new-standard-feature" class="text">
          <xsl:attribute name="data-validate">{required: false}</xsl:attribute>
        </input>
        
        <a href="#" id="add-standard-feature" class="button">Add</a>

      </fieldset>
      
      
      <fieldset class="right half">
        <h3>Optional Features</h3>

        <ul class="select-list" id="optional-features">
          <xsl:for-each select="$data/Features/AutomotiveFeatureEditInfo">
            <xsl:if test="./FeatureType = 'optional'">
              <li data-id="{./ID}">
                <span>
                  <xsl:value-of select="./FeatureDescription" />
                </span>
                <a href="#" class="select-item-delete" data-id="{./ID}">Delete</a>
              </li>
            </xsl:if>
          </xsl:for-each>
        <xsl:text>
        </xsl:text></ul>
       
          <input type="text" id="new-optional-feature" class="text allow-lowercase">
            <xsl:attribute name="data-validate">{required: false}</xsl:attribute>
          </input>

        <a href="#" id="add-optional-feature" class="button">Add</a>
      </fieldset>
      
    </div>
    
    <input type="hidden" name="listing-code" value="{$data/Code}" />
    <input type="hidden" name="listing-optional-features" id="listing-optional-features" />
    <input type="hidden" name="listing-standard-features" id="listing-standard-features" />
    
  </form>
  
</xsl:template>
    
    
<!-- Listing Videos Template -->
    
    
<xsl:template name="listingVideos">
  <xsl:param name="data" />
 

      <div class="group-box">
        <div class="underlay">
          <h1><span class="videos">&nbsp;</span>Videos</h1>
        </div>
          
        <ul id="listing-videos">
          <xsl:for-each select="$data/Videos/ListingVideoEditInfo">
            <li>
              <a href="#" class="video-viewer" data-video-source="{./VideoSource}" data-video-data="{./VideoData}">View Video</a>
              <h4>
                <xsl:value-of select="./Title" />
              </h4>
              <xsl:choose>
                <xsl:when test="./VideoSource = 'YouTube'">
                  <div class="video-thumbnails">
                    <!--<img src="http://images.48.akamai.uniquewebsites.com.au/youtube.png" width="48" height="48" alt="YoutTube" />-->
                    <img src="http://img.youtube.com/vi/{./VideoData}/1.jpg" width="120" height="90" alt="Video thumbnail 1" />
                    <img src="http://img.youtube.com/vi/{./VideoData}/2.jpg" width="120" height="90" alt="Video thumbnail 2" />
                    <img src="http://img.youtube.com/vi/{./VideoData}/3.jpg" width="120" height="90" alt="Video thumbnail 3" />
                  </div>
                  <form method="post">
                    <input type="hidden" name="video-id" value="{./ID}" />
                    <input type="hidden" name="listing-code" value="{$data/Code}" />
                    <input type="hidden" name="delete-video" value="true" />
                    <input type="submit" name="delete-video-button" value="Delete Video" class="delete-video button" />
                  </form>
                </xsl:when>
              </xsl:choose>
              <div class="video-details" style="display: none">&nbsp;</div>
            </li>
          </xsl:for-each>
          <xsl:if test="count($data/Videos/ListingVideoEditInfo) = 0">
            <li class="no-results">
              No videos have been associated with this listing yet.
            </li>
          </xsl:if>
        </ul>
      <h3>Add Videos</h3>
      <ul class="full">
        <li>
          Copy and paste the full link to the YouTube video you'd like to add, then click the Add YouTube Video button.<br />
          <label><b>YouTube Link:</b></label>
          <input type="text" class="text allow-lowercase" name="youtube-url" id="youtube-url" maxlength="100" style="width: 450px; margin: 0 5px 0 0;" />
          <a href="#" id="add-youtube" class="lightbox button" data-listing-code="{$data/Code}">Add YouTube Video</a>
        </li>
      </ul>
              
    </div>
 
                
</xsl:template>
    
    
<!-- Listing Images Template -->
    
    
<xsl:template name="listingImages">
  <xsl:param name="data" />
  
  <form method="post" id="manage-images-form">
  <div class="group-box">
    <div class="underlay">
      <h1><span class="photos">&nbsp;</span>Photos
        <input type="submit" class="button" name="update-photos" id="update-photos" value="Update Photos" />
      </h1>
    </div>
    <!-- Display existing thumbs -->
    <xsl:variable name="imgCount" select="count($data/Images/ListingImageEditInfo)"/>
    <ul id="listing-thumbnails">
      <xsl:for-each select="$data/Images/ListingImageEditInfo">
        <li data-photo-id="{./ID}">
          <xsl:attribute name="data-photo-caption">
            <xsl:choose>
              <xsl:when test="./ImageTitle !=''">
                <xsl:value-of select="./ImageTitle" />
              </xsl:when>
              <xsl:otherwise>&nbsp;</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
              
          <div class="thumbnail">
            <img src="{scripts:GetImageUrl(./ImageUrl, 108, 108)}" alt="{$data/ImageTitle}" />
          </div>
          <a href="{./ImageUrl}" class="lightbox view-image" title="View full photo">View full photo</a>
          <a href="#" class="caption-image" title="Edit photo caption">Edit photo caption</a>
          <a href="#" class="delete-image" data-image-id="{./ID}" title="Delete photo">Delete this photo</a>
        </li>
      </xsl:for-each>
      
      <xsl:call-template name="thumbnailLoop">
        <xsl:with-param name="i" select="$imgCount + 1" />
        <xsl:with-param name="count">24</xsl:with-param>
      </xsl:call-template>
    </ul>
    
    <input type="hidden" id="photo-order" name="photo-order" />
    <input type="hidden" id="photo-captions" name="photo-captions" />
    <input type="hidden" id="delete-photos" name="delete-photos" />
    <input type="hidden" name="listing-code" value="{$data/Code}" />
    
    <!-- Display image uploader -->
    <xsl:if test="$imgCount &lt; 24">
      <div style="float: left; clear: both">
      <h3>Upload More Photos</h3>
      <textarea  id="log" style="display: none; width: 100%; height: 150px; font-size:  11px" spellcheck="false" wrap="off"><xsl:text>
        </xsl:text></textarea>
      <div id="uploader">Sorry, but your browser doesn't support file uploads.</div>
      <a id="clear" href="#">Clear queue</a>
      </div>
    </xsl:if>
  
    <!-- Image Caption Edit -->
    <div id="caption-edit" data-photo-id="" class="group-box small">
      <div class="underlay">
        <h1>
          <span class="photos">&nbsp;</span>Edit Photo Caption
        </h1>
      </div>
      <div id="caption-image">
        <img src="#" alt="image" />
      </div>
      <input type="text" maxlength="100" class="text" id="image-caption">
        <xsl:attribute name="data-validate">{required: false, minlength: 3, maxlength: 100'}}</xsl:attribute>
      </input>
      <a id="set-image-caption" href="#" class="button">Set Caption</a>
    </div>
  
  </div>
  </form>
  <script type="text/javascript">
    <![CDATA[

    // Init lightboxes
    $('#listing-thumbnails .lightbox').colorbox();

    $(function() {
      function log() {
        var str = "";
    
        plupload.each(arguments, function(arg) {
          var row = "";
    
          if (typeof(arg) != "string") {
            plupload.each(arg, function(value, key) {
              // Convert items in File objects to human readable form
              if (arg instanceof plupload.File) {
                // Convert status to human readable
                switch (value) {
                  case plupload.QUEUED:
                    value = 'QUEUED';
                    break;
    
                  case plupload.UPLOADING:
                    value = 'UPLOADING';
                    break;
    
                  case plupload.FAILED:
                    value = 'FAILED';
                    break;
    
                  case plupload.DONE:
                    value = 'DONE';
                    break;
                }
              }
    
              if (typeof(value) != "function") {
                row += (row ? ', ': '') + key + '=' + value;
              }
            });
    
            str += row + " ";
          } else {
            str += arg + " ";
          }
        });
    
        $('#log').val($('#log').val() + str + "\r\n");
      }
    
      $("#uploader").pluploadQueue({
        // General settings
        runtimes: 'html5,gears,browserplus,flash,html4',
        url: '/easylistimageupload.ashx',
        max_file_size: '10mb',
        chunk_size: '10kb',
        unique_names: true,
        
    
        // Resize images on clientside if we can
        resize: {width: 640, height: 480, quality: 90},
    
        // Specify what files to browse for
        filters: [
          {title: "Image files", extensions: "jpg,jpeg"},
        ],
    
        // Flash/Silverlight paths
        flash_swf_url: 'http://easypagecdn.akamai.uniquewebsites.com.au/plupload_1432/plupload.flash.swf',
        silverlight_xap_url: 'http://easypagecdn.akamai.uniquewebsites.com.au/plupload_1432/plupload.silverlight.xap',
    
        // PreInit events, bound before any internal events
        preinit: {
          Init: function(up, info) {
            log('[Init]', 'Info:', info, 'Features:', up.features);
          },
    
          UploadFile: function(up, file) {
            log('[UploadFile]', file);
    
            // You can override settings before the file is uploaded
            // up.settings.url = 'upload.php?id=' + file.id;
            up.settings.multipart_params = {listingCode: ']]><xsl:value-of select="$data/Code" /><![CDATA['};
          }
        },
    
        // Post init events, bound after the internal events
        init: {
          Refresh: function(up) {
            // Called when upload shim is moved
            log('[Refresh]');
          },
    
          StateChanged: function(up) {
            // Called when the state of the queue is changed
            log('[StateChanged]', up.state == plupload.STARTED ? "STARTED": "STOPPED");
          },
    
          QueueChanged: function(up) {
            // Called when the files in queue are changed by adding/removing files
            log('[QueueChanged]');
          },
    
          UploadProgress: function(up, file) {
            // Called while a file is being uploaded
            log('[UploadProgress]', 'File:', file, "Total:", up.total);
          },
    
          FilesAdded: function(up, files) {
            // Callced when files are added to queue
            log('[FilesAdded]');
    
            plupload.each(files, function(file) {
              log('  File:', file);
            });
          },

          UploadComplete: function(){
            $('#update-photos').click();
          },
    
          Error: function(up, args) {
            if (args.file) {
              log('[error]', args, "File:", args.file);
            } else {
              log('[error]', args);
            }
          }
        }
      });
    
      $('#log').val('');
      $('#clear').click(function(e) {
        e.preventDefault();
        $("#uploader").pluploadQueue().splice();
      });
    });
]]>
</script>
  
</xsl:template>
    
<xsl:template name="thumbnailLoop">
  
  <xsl:param name="i" />
  <xsl:param name="count" />

  <xsl:if test="$i &lt;= $count">
    <li class="thumb no-photo">
      <xsl:value-of select="$i" />
    </li>
  </xsl:if>
  
  <xsl:if test="$i &lt;= $count">
    <xsl:call-template name="thumbnailLoop">
      <xsl:with-param name="i">
        <xsl:value-of select="$i + 1"/>
      </xsl:with-param>
      <xsl:with-param name="count">
        <xsl:value-of select="$count"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

</xsl:template>
      
</xsl:stylesheet>
