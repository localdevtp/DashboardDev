	$(function(){
		
		$("#ErrMsgDiv").hide();
		
		$(document).ajaxStart(function () {
			$('#loading-bg').show();
			$("#loading").show();
		});
		
		$(document).ajaxComplete(function () {
			$('#loading-bg').hide();
			$("#loading").hide();
		});
			
		var	CatID = getURLParameter("CatID");		
		var	Title = getURLParameter("Title");

		$('#listing-title').val(Title);
						
		// setup form function - Load car & motorcycle attributes
		if (CatID == "60")
		{
			//LoadAllCarMakes();
			LoadGlassEditInfo();
		}
		if (CatID == "67")
		{
			LoadMotorGlassEditInfo();
		}	
		/*else if (CatID == "80")
		{
			LoadAllCustomMakes('TruckNBus');		
		}	
		else if (CatID == "600")
		{
			LoadAllCustomMakes('VintageClassic');
		}
		else if (CatID == "601")
		{
			LoadAllCustomMakes('HotCustom');
		}*/
				
		$('#ConfirmGlass').on('click',function(e){
			
			var	CatID = getURLParameter("CatID");		
			if (CatID == "60")
			{
				var Make = $("#easylist-Makes option:selected").val().trim();
				var Model = $("#easylist-Models option:selected").val().trim();
				var Year = $("#easylist-Years option:selected").val().trim();
				
				var StyleType = GetBodyStyle($("#easylist-Styles option:selected").val().trim());
				var Style = $("#easylist-Styles option:selected").val().trim();
				
				var TransType = GetTransType($("#easylist-Transmission option:selected").val().trim());
				var Transmission = $("#easylist-Transmission option:selected").val().trim();
				
				var SelVariant = $("#easylist-Variant option:selected").text().trim();
				if (SelVariant == "Select an option") SelVariant = "";
				
				var Variant = "";
				var Series = "";
				var Engine = "";
				var EngineSize = "";
				var EngineCC = "";
				var NVIC = "";
				var NoOfDoors = "";
				var NoOfSeats = "";
				var DriveType = "";
				var FuelType = "";
				
				// Interprete Variant
				if (SelVariant != '')
				{
					try
  					{
  						var AutoVariantInfo = jQuery.parseJSON($("#easylist-Variant option:selected").val().trim()); 
	  					
						Series = AutoVariantInfo.Series;
						Variant = AutoVariantInfo.Variant;
						
  					}
					catch(err)
  					{
  						//Handle errors here
					}
				}
				
				var Title = $("#listing-title").val().trim();
				var OverwriteStdFeaturesList = $("#OverwriteStdFeatures").is(':checked');
				var StdFeaturesList = $("#easylist-standard-features").val();
				var OptFeaturesList = $("#easylist-optional-features").val();
				
				//--------------------------------------------------------------------------
				// Validation : Check required fields
				if (Make == "" || Model == "" || Year == "" || Style == "" || Transmission == ""  || SelVariant == "")
				{
					$("#ErrMsgDiv").show();
					$("#ErrMsg").text("Please select make, model, year, styles, transmission & variant for your vechicle!");
					e.preventDefault();
					return;
				}
				//--------------------------------------------------------------------------
				
				parent.FixAutoSpec(Make, Model, Year, Series, StyleType, Style, TransType, Transmission, Variant, 
								   AutoVariantInfo, 
								   Title, OverwriteStdFeaturesList, StdFeaturesList, OptFeaturesList);
				
			}
			else if (CatID == "67")
			{
				var Make = $("#easylist-Motor-Makes option:selected").val().trim();
				var Model = $("#easylist-Motor-Models option:selected").val().trim();
				var Year = $("#easylist-Motor-Years option:selected").val().trim();
				
				var VariantInfo = $("#easylist-Motor-Variant option:selected").val().trim();
				
				var Variant = "";
				var Series = "";
				var BodyDesc = "";
				var TrmDesc = "";
				var EngCylinders = "";
				var EngDesc = "";
				var EngSizeDesc = "";
				var NVIC = "";
					
				// Interprete Variant
				if (VariantInfo != '')
				{
				 	var MotorVariantInfo = jQuery.parseJSON(VariantInfo); 
					
					Variant = MotorVariantInfo.Variant;
					Series = MotorVariantInfo.Series;
					BodyDesc = MotorVariantInfo.Styles;
					TrmDesc = MotorVariantInfo.Transmission;
					EngCylinders = MotorVariantInfo.Cylinder;
					EngDesc = MotorVariantInfo.Engine;
					EngSizeDesc = MotorVariantInfo.EngineCC;
					NVIC = MotorVariantInfo.NVIC;
				}
				
				var Title = $("#listing-title").val().trim();
				var OverwriteStdFeaturesList = $("#OverwriteStdFeatures").is(':checked');
				var StdFeaturesList = $("#easylist-standard-features").val();

				//--------------------------------------------------------------------------
				// Validation : Check required fields
				if (Make == "" || Model == "" || Year == "" || Variant == "")
				{
					$("#ErrMsgDiv").show();
					$("#ErrMsg").text("Please select make, model, year & variant for your motorbikes!");
					e.preventDefault();
					return;
				}
				//--------------------------------------------------------------------------
				
				parent.FixMotorSpec(Make, Model, Year, Variant, Series, BodyDesc, TrmDesc, EngCylinders, EngDesc, EngSizeDesc, NVIC, Title, OverwriteStdFeaturesList, StdFeaturesList);
			}
		});
		
		$('#CancelGlass').on('click',function(e){
			parent.CancelPopup();
			
		});
	});
		

	function RefreshControls() {
		/*var selectcontrols = $('#AutomotiveListing select');
		for (var i = 0; i < $(selectcontrols).length; i++) {
			var c = $(selectcontrols[i]).parents('.control-group');
			
			if($(selectcontrols[0]).val() == '')
			{
				if (i ==0)
				{
					$(c).removeClass('hidden');
					$('#group-standard-features').hide();
					$('#group-optional-features').hide();
					$('#easylist-standard-features').empty();
					$('#easylist-optional-features').empty();
					$('#easylist-specs').empty();
				}
				else
				{
					$(c).addClass('hidden');
				}
			}
			else
			{
				if($('option',selectcontrols[i]).length > 1) {
					$(c).removeClass('hidden');
				} else {
					$(c).addClass('hidden');
				}
			}
		}*/
	}
	
	function RefreshMotorControls() {
		var selectcontrols = $('#MotorcycleListing select');
		for (var i = 0; i < $(selectcontrols).length; i++) {
			
			var c = $(selectcontrols[i]).parents('.control-group');
			if($(selectcontrols[0]).val() == '')
			{
				if (i ==0)
				{
					$(c).removeClass('hidden');
				}
				else
				{
					$(c).addClass('hidden');
				}
			}
			else
			{
				if($('option',selectcontrols[i]).length > 1) {
					$(c).removeClass('hidden');
				} else {
					$(c).addClass('hidden');
				}
			}
		}
	}
	
	function CustomPricing(show)
	{
		var IsRetailUser = false;
		if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
		
		if (IsRetailUser) return; // Not Applicable for retail user
		
		if (show)
		{
			$("#custom-pricing").show();
			$("#standard-pricing").hide();
		}else
		{
			$("#custom-pricing").hide();
			$("#standard-pricing").show();
		}
	}
	
	function CatChange(element, childID) {
		// Get Sub categories
		var NewChildID = childID + 1;			
		
		// Destroy all child underneath
		$('.CatLvl' + NewChildID).remove();
		for (var i = NewChildID; i < 6; i++) {
			$('.CatLvl' + i).remove();
		}
		
		if ($(element).val() == 0){
			//$("#next").hide();
			return;
		}
		
		var CatLvl = $(element).val();
		
		// Check if category have UI Editor
		$.getJSON('/api?api=CatInfo&CatID=' + CatLvl , function (data) {
			var CatInfo = jQuery.parseJSON(data.Result);
			$('#CustomAttr').empty();
			$('.lst-condition').show();
			
			CustomPricing(false);
			
			if (CatInfo.UIEditor)
			{
				$("#listing-category-id").val(CatInfo.ID);
				$("#listing-category-name").val(CatInfo.Name);
				$("#listing-category-path").val(CatInfo.Path);
				$("#next").show();
				
				$('#listing-title').val('');
				$('#listing-title').prop('readonly', false);
				
				if (CatInfo.UIEditor == 'AutomotiveListing'){
					
					$(".CustomMakeModelListingTemplateSelected").hide();
					
					if (CatInfo.Name == "Trucks and Buses For Sale")
					{
						LoadAllCustomMakes('TruckNBus');
						
						$(".AutomotiveListingTemplate").hide();
						$("#CustomMakeModelListing").show();
						
						CustomPricing(true);
						
					} else if (CatInfo.Name == "Hot Rods and Custom Cars")
					{
						LoadAllCustomMakes('HotCustom');
						
						$(".AutomotiveListingTemplate").hide();
						$("#CustomMakeModelListing").show();
						
						CustomPricing(true);
					}
					else if (CatInfo.Name == "Vintage and Classic Cars")
					{
						LoadAllCustomMakes('VintageClassic');
						
						$(".AutomotiveListingTemplate").hide();
						$("#CustomMakeModelListing").show();
						
						CustomPricing(true);					
					}
					else
					{
						LoadAllCarMakes();
						
						$(".AutomotiveListingTemplate").show();
						$("#CustomMakeModelListing").hide();
						
						$('#listing-title').prop('readonly', true);
						
						CustomPricing(true);
						
					}
					$("#UIEditorLink").val("AutomotiveListing");
					$(".AutomotiveListingAddInfo").show();
					$(".MotorcycleListingTemplate").hide();
					$("#group-motor-features").hide();
					$(".GMListingTemplate").hide();
					
				}
				else if(CatInfo.UIEditor == 'MotorcycleListing')
				{
					LoadAllMotorMakes();
					
					$(".AutomotiveListingAddInfo").hide();
					$("#UIEditorLink").val("MotorcycleListing");
					$(".AutomotiveListingTemplate").hide();
					$(".MotorcycleListingTemplate").show();
					$(".GMListingTemplate").hide();
					
					$("#CustomMakeModelListing").hide();
					$(".AutomotiveListingAddInfo").show();
					
					$('#listing-title').prop('readonly', true);
					
					CustomPricing(true);
				}
				else if(CatInfo.UIEditor == 'Custom')
				{
					$(".AutomotiveListingAddInfo").hide();
					
					$('#listing-title').val('');
					$('#listing-title').prop('readonly', false);
					$("#CustomMakeModelListing").hide();
					$(".AutomotiveListingTemplate").hide();
					$(".MotorcycleListingTemplate").hide();
					$("#group-motor-features").hide();
					
					$.getJSON('api?api=CatUI&CatID=' + CatLvl + '&Mode=New', function (data) {
						if (data.State == 1)
						{
							//alert(CatLvl);
							if (CatLvl == 528 || CatLvl == 530 || CatLvl == 532 || CatLvl == 533  || CatLvl == 536  || CatLvl == 538) { $('.lst-condition').hide(); }
							
							$('#CustomAttr').append(data.Result);
							$('.GMListingTemplate').show();
							
							// Init Bootstrap Tooltips
							$('[data-toggle="tooltip"]').tooltip();
							
							$.metadata.setType('attr', 'data-validate');
							$('#listing-wizard').each(function () {
								$(this).validate();	
							});
						}
						
						$("#UIEditorLink").val("GM");
					});
					
				}else
				{
					$(".AutomotiveListingAddInfo").hide();
					
					if (CatLvl == 528 || CatLvl == 530 || CatLvl == 532 || CatLvl == 533  || CatLvl == 536  || CatLvl == 538) { $('.lst-condition').hide(); }
					
					$('#listing-title').val('');
					$('#listing-title').prop('readonly', false);
					
					$("#CustomMakeModelListing").hide();
					$(".AutomotiveListingTemplate").hide();
					$(".MotorcycleListingTemplate").hide();
					$("#group-motor-features").hide();
					$("#UIEditorLink").val("GM");
					$(".GMListingTemplate").hide();
					//$("#next").click();
				}
				return;
			}
			else
			{
				$(".AutomotiveListingTemplate").hide();
				$(".MotorcycleListingTemplate").hide();
				$("#group-motor-features").hide();
				
				$(".GMListingTemplate").hide();
				$("#CustomMakeModelListing").hide();
				$(".CustomMakeModelListingTemplateSelected").hide();
				
				$(".AutomotiveListingAddInfo").hide();
				$('#listing-title').val('');
				$('#listing-title').prop('readonly', false);
				
				$("#next").hide();
				
				$.getJSON('/api?api=SubLevelHTML&ParentCatID=' + CatLvl, function (data) {
					
					//-----------------------------------------------------------
					// Run again in case if user keep on select parent category
					// Get Sub categories
					var NewChildID = childID + 1;			
					
					// Destroy all child underneath
					$('.CatLvl' + NewChildID).remove();
					for (var i = NewChildID; i < 6; i++) {
						$('.CatLvl' + i).remove();
					}
					//-----------------------------------------------------------
					
					//  No more subcategory, and no UI explicitly indicated, go to GM Type
					if (data.Result == '<option value="0">Select</option>'){
						$("#listing-category-id").val(CatInfo.ID);
						$("#listing-category-name").val(CatInfo.Name);
						$("#listing-category-path").val(CatInfo.Path);
						$("#next").show();
						$("#UIEditorLink").val("GM");
						$("#next").click();
						return;
					}
					
					$('<select/>', {
						'id': 'CatLvl' + NewChildID,
						'class': 'CatLvl' + NewChildID + ' required',
						'style': 'display: block; margin-top:10px;',
						'onchange': 'CatChange(this, ' + NewChildID + ');',
						html: data.Result
					}).appendTo($('#CategorySelection'));
				});
			}
		});
		
	}
	
	
	function LocationValidation(e){
		//--------------------------------------------------
		/*if ($("#listing-location-validator").val() != "true")
	{
	$("#listing-location-validate").show();
	$("#listing-location" ).focus();
	return false;
	}else
	{
	return true;
	}*/
		
		$.ajax({
			async: false,
			type: "GET",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			url: '/api?api=LocInfo&Location=' + $('#listing-location').val(),
			success: function(data) {
			if (data.State == 1)
			{
			$("#listing-location").removeClass("error");
			$("#listing-location-validator").val("true");
			$("#listing-location-validate").hide();
			
			return true;
		}else
			   {
			   $("#listing-location").addClass("error");
		$("#listing-location-validator").val("false");
		$("#listing-location-validate").show();
		
		$('#submit').resetbtnload();
		$('#checkout').resetbtnload();
		$('#publish').resetbtnload();
		
		e.preventDefault();
		return false;
	}
	}
	});
	
	//--------------------------------------------------
	}
		
		function UserCodeCatalog()
	{
		var UserCode = $('#listing-usercode option:selected').val();
		var CatalogData = $('#listing-usercode option:selected').attr('data-catalog');
		if (CatalogData != "" && CatalogData != "[]" && CatalogData != undefined)
		{
			var CatalogObj = jQuery.parseJSON(CatalogData);
			
			var SelectControlDiv = "<div class='control-group'><label class='control-label'>Catalog</label>" + 
				"<div class='controls'>";
			SelectControlDiv += "<select class='drop-down required' id='listing-catalog' name='listing-catalog'>";
			
			$.each(CatalogObj, function(key,catalog) {
				//alert(catalog.ID);
				var Selected = "";
				if (catalog.Selected == "1") Selected = "selected='selected'";
				SelectControlDiv += "<option value='" + catalog.ID + "' " + Selected + ">" + catalog.Name + "</option>";
			});
			
			SelectControlDiv += "</select>";
			SelectControlDiv += "</div></div>";
			
			$('.listingCatalog').html(SelectControlDiv);
			$('.listingCatalog').show();
			
		}else
		{
			$('.listingCatalog').empty();
			$('.listingCatalog').hide();
		}
	}
	
	
	
	function FieldValidation()
	{
		//--------------------------------------
		// Required field Validation
		
		$("#listing-location").addClass("required");
		$("#listing-title").addClass("required");
		$("#listing-summary").addClass("required");
		$("#listing-description-wysiwyg").addClass("required");
		
		//$("#listing-price").addClass("required");
		//$("#listing-was-price").addClass("required");
		
		if ($("#standard-pricing").is(":visible")) {
			// handle non visible state
			$("#listing-price").addClass("required");
			$("#listing-driveaway-price").removeClass("required");
		}
		else
		{
			$("#listing-price").removeClass("required");
			
			// handle visible state
			if ($("#listing-driveaway-price").val() == "" 
				&& $("#listing-sale-price").val() == ""
				&& $("#listing-unqualified-price").val() == "" )
					{
						$("#listing-driveaway-price").addClass("required");
						
						alertModal('Please enter Drive Away Price,Sale Price or Unqualified Price.','Error','warning');
					}
					else
					{
						$("#listing-driveaway-price").removeClass("required");
					}
				}
				
				if ($("#reset-car-attr").val() == "false") return;
				
				if ($("#listing-category-id").val() == undefined || $("#listing-category-id").val() == "")
					{
						$("#CatLvl1").addClass("required");
					}else
					{
						$("#CatLvl1").removeClass("required");
					}
				
				var UIEditorLink = $("#UIEditorLink").val();
				switch (UIEditorLink)
				{
					case "GM":
						$("#easylist-Makes").removeClass("required");
						$("#easylist-Models").removeClass("required");
						$("#easylist-Years").removeClass("required");
						$("#easylist-Styles").removeClass("required");
						$("#easylist-Transmission").removeClass("required");
						$("#easylist-Variant").removeClass("required");
						
						$("#easylist-Motor-Makes").removeClass("required");
						$("#easylist-Motor-Models").removeClass("required");
						$("#easylist-Motor-Years").removeClass("required");
						$("#easylist-Motor-Styles").removeClass("required");
						$("#easylist-Motor-Transmission").removeClass("required");
						$("#easylist-Motor-Variant").removeClass("required");
						
						$("#easylist-custom-Makes").removeClass("required");
						$("#easylist-custom-Models").removeClass("required");
						$("#easylist-custom-Year").removeClass("required");
						
						break;
						
					case "AutomotiveListing":
						
						var CatID = $("#listing-category-id").val();
						
						// Truck and bus, Hot rods, Vintage car
						if (CatID == 80 || CatID == 600 || CatID == 601)
						{
							$("#easylist-custom-Makes").addClass("required");
							$("#easylist-custom-Models").addClass("required");
							$("#easylist-custom-Year").addClass("required");
							
							$("#easylist-Makes").removeClass("required");
							$("#easylist-Models").removeClass("required");
							$("#easylist-Years").removeClass("required");
							$("#easylist-Styles").removeClass("required");
							$("#easylist-Transmission").removeClass("required");
							$("#easylist-Variant").removeClass("required");
						}
						else
						{
							$("#easylist-Makes").addClass("required");
							$("#easylist-Models").addClass("required");
							$("#easylist-Years").addClass("required");
							$("#easylist-Styles").addClass("required");
							$("#easylist-Transmission").addClass("required");
							$("#easylist-Variant").addClass("required");
						}
						
						$("#easylist-Motor-Makes").removeClass("required");
						$("#easylist-Motor-Models").removeClass("required");
						$("#easylist-Motor-Years").removeClass("required");
						$("#easylist-Motor-Styles").removeClass("required");
						$("#easylist-Motor-Transmission").removeClass("required");
						$("#easylist-Motor-Variant").removeClass("required");
						
						break;
						
					case "MotorcycleListing":
						$("#easylist-Makes").removeClass("required");
						$("#easylist-Models").removeClass("required");
						$("#easylist-Years").removeClass("required");
						$("#easylist-Styles").removeClass("required");
						$("#easylist-Transmission").removeClass("required");
						$("#easylist-Variant").removeClass("required");
						
						$("#easylist-Motor-Makes").addClass("required");
						$("#easylist-Motor-Models").addClass("required");
						$("#easylist-Motor-Years").addClass("required");
						$("#easylist-Motor-Styles").addClass("required");
						$("#easylist-Motor-Transmission").addClass("required");
						$("#easylist-Motor-Variant").addClass("required");
						
						$("#easylist-custom-Makes").removeClass("required");
						$("#easylist-custom-Models").removeClass("required");
						$("#easylist-custom-Year").removeClass("required");
						
						break;
						
					default:
				}
				
				if (UIEditorLink == "MotorcycleListing" || UIEditorLink == "AutomotiveListing")
				{
					if ($("#listing-vehicle-registered").prop('checked'))
					{
						$("#listing-vehicle-rego").addClass("required");
						//$("#listing-vehicle-expiry-month").addClass("required");
						//$("#listing-vehicle-expiry-year").addClass("required");
						
						$("#listing-vehicle-VinEngine").removeClass("required");
						$("#listing-vehicle-VinEngine-No").removeClass("required");
					}else
					{
						$("#listing-vehicle-rego").removeClass("required");
						//$("#listing-vehicle-expiry-month").removeClass("required");
						//$("#listing-vehicle-expiry-year").removeClass("required");
						
						$("#listing-vehicle-VinEngine").addClass("required");
						$("#listing-vehicle-VinEngine-No").addClass("required");	
					}
				}
			}
	
	function ResetCatAttr()
	{
		if ($("#reset-car-attr").val() == "true")
		{
			$("#listing-make").val($("#easylist-Makes option:selected").val().trim());
			$("#listing-model").val($("#easylist-Models option:selected").val().trim());
			$("#listing-year").val($("#easylist-Years option:selected").val().trim());
			$("#listing-body-style").val($("#easylist-Styles option:selected").val().trim());
			$("#listing-transmission").val($("#easylist-Transmission option:selected").val().trim());
			$("#listing-variant").val($("#easylist-Variant option:selected").text().trim());
			
			$("#listing-motor-make").val($("#easylist-Motor-Makes option:selected").val().trim());
			$("#listing-motor-model").val($("#easylist-Motor-Models option:selected").val().trim());
			$("#listing-motor-year").val($("#easylist-Motor-Years option:selected").val().trim());
			$("#listing-motor-variant").val($("#easylist-Motor-Variant option:selected").val().trim());
			
			$("#listing-custom-make").val($("#easylist-custom-Makes option:selected").val().trim());
			$("#listing-custom-model").val($("#easylist-custom-Models option:selected").text().trim());
			$("#listing-custom-year").val($("#easylist-custom-Year").val().trim());
		}
	}
	
	function ReloadImages()
	{
		var UserTempKey = getCookie('ELID');
		var UserCode = getCookie('ELUS');
		var ImageOrder = $("#photo-order").val();
		var NewImageOrder = '';
		
		// Load temporary Images
		$.getJSON('/api?api=ListingTempLoad&UserCode=' + UserCode + '&UserTempKey=' + UserTempKey + '&ImageOrder=' + ImageOrder, 
				  function (data) {
			var items = [];	
			
			$.each(jQuery.parseJSON(data.Result), function (key, value) {
				items.push(RenderImageLI(UserCode, UserTempKey, value.ImageCode, value.Url));
				
				if (NewImageOrder != '') NewImageOrder += ','
					NewImageOrder += value.ImageCode;
			});
			
			$('#listing-thumbnails').html(items.join(''));
			$("#photo-order").val(NewImageOrder);
		});
	}
	
	function RenderImageLI(UserCode, UserTempKey, ImgCode, ImgURL) {
		var ImageDeleteURL = '/api?api=ListingTempDel&UserCode=' + UserCode + '&UserTempKey=' + UserTempKey + '&ImgCode=' + ImgCode;
		
		var NewImgLI = 
			'<li class="span3 thumb" data-photo-id="'+ ImgCode + '" data-photo-caption="' + ImgCode + '">' +
				'<div class="thumbnail">' +
					'<img src="' + ImgURL + '" alt="'+ ImgCode + '" />' +
						'</div>' + 
							'<a href="' + ImgURL + '" class="lightbox view-image">' +
								'<i class="icon-eye"></i>' +
									'</a>' +
										'<a href="' + ImageDeleteURL + '" id="delete-image-new" class="delete-image IsNew" data-image-id="' + ImgCode + '" title="Delete photo">' +
											'<i class="icon-remove"></i>' +
												'</a>' +
													'</li>';
				
				return NewImgLI;
			}
	
	function getCookie(c_name)
	{
		var c_value = document.cookie;
		var c_start = c_value.indexOf(" " + c_name + "=");
		if (c_start == -1)
		{
			c_start = c_value.indexOf(c_name + "=");
		}
		if (c_start == -1)
		{
			c_value = null;
		}
		else
		{
			c_start = c_value.indexOf("=", c_start) + 1;
			var c_end = c_value.indexOf(";", c_start);
			if (c_end == -1)
			{
				c_end = c_value.length;
				  }
					  c_value = unescape(c_value.substring(c_start,c_end));
				  }
				return c_value;
			}
	
	function getURLParameter(name) {
		return decodeURI(
			(RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
		);
	}
		