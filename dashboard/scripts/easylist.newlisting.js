	
		function RefreshControls() {
			var selectcontrols = $('#AutomotiveListing select');
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
						//$('#easylist-specs').empty();
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
							
							//CustomPricing(true);
							
						} else if (CatInfo.Name == "Hot Rods and Custom Cars")
						{
							LoadAllCustomMakes('HotCustom');

							$(".AutomotiveListingTemplate").hide();
							$("#CustomMakeModelListing").show();
							
							//CustomPricing(true);
						}
						else if (CatInfo.Name == "Vintage and Classic Cars")
						{
							LoadAllCustomMakes('VintageClassic');

							$(".AutomotiveListingTemplate").hide();
							$("#CustomMakeModelListing").show();
							
							//CustomPricing(true);					
						}
						else
						{
							LoadAllCarMakes();
														
							$(".AutomotiveListingTemplate").show();
							$("#CustomMakeModelListing").hide();
							
							$('#listing-title').prop('readonly', true);
							
							//CustomPricing(true);

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
						
						//CustomPricing(true);
					}
					else if(CatInfo.UIEditor == 'Custom')
					{
						RemoveVINRegNoValidation();
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
					
					PricingStructureChanged();
					
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
						
						//Retire Rescue Categories under Pets section CatLvl 526 = "Pets and Horses"
						if(CatLvl == 526)
						{
							var noRescue = '<option value="">Select</option><option value="527">Bird Food and Accessories</option><option value="528">Birds</option><option value="529">Cat Food and Accessories</option><option value="530">Cats</option><option value="531">Dog Food and Accessories</option><option value="532">Dogs</option><option value="533">Fish</option><option value="534">Fish Food and Accessories</option><option value="535">Horse Accessories</option><option value="536">Horses</option><option value="537">Other Accessories</option><option value="538">Other Pets</option>';
							data.Result = noRescue;
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
		
		
		$(function(){
			// init validation plugin
			$.metadata.setType('attr', 'data-validate');
			$('#new-listing').each(function () {
				$(this).validate();
			});
			
			// setup form fields
			/*
			$("#listing-price").maskMoney();
			$("#listing-was-price").maskMoney();
			
			$("#listing-driveaway-price").maskMoney();
			$("#listing-sale-price").maskMoney();
			$("#listing-unqualified-price").maskMoney();
			*/
			$('#listing-price').autoNumeric('init');
			$('#listing-was-price').autoNumeric('init');
			$('#listing-driveaway-price').autoNumeric('init');
			$('#listing-sale-price').autoNumeric('init');
			$('#listing-unqualified-price').autoNumeric('init');
			
			
			UserCodeCatalog();
			//-----------------------------------------------------------------
			// User Catalog List
			//-----------------------------------------------------------------
			$("#listing-usercode").change(function(e){
				UserCodeCatalog();
			});
			
			$("#parent-selector :input").attr("disabled", true);
			
			$('#listing-summary').val($('#listing-summary').val().trim());
			$('#listing-description').val($('#listing-description').val().trim());
			$('#group-standard-features').hide();
			$('#group-optional-features').hide();
			//$('#group-car-spec').hide();
			$('#group-motor-spec').hide();
			
			//$('.AutomotiveListingAddInfo').hide();
			
			// setup form functions - Listing condition logic
			$(".listing-condition").change(function(e){
				if ($('.listing-condition option:selected').val() == 'New' || $('.listing-condition option:selected').val() == '' )
				{
					$(".listing-condition-desc").hide();
					$(".listing-condition-desc").removeClass("required");
				}else
				{
					$(".listing-condition-desc").show();
					$(".listing-condition-desc").addClass("required");
				}
			});
			
			//$(".listing-condition-desc").hide();
			
			// setup form function - Category load
			$.getJSON('/api?api=RootCategory', function (data) {
				var items = [];
				$("#CatLvl1").html(data.Result);
				$("#CatLvl1").show();
				
				var CatSel = getURLParameter('CatSel');
				if (CatSel == 1)
				{
					// Reload category info only if the listing not saved before
					if($("#ListingCode").val() == "")
					{
						$("#CatLvl1 option[value='" + $("#CatPathSet").val() + "']").attr("selected", "selected");
						CatChange("#CatLvl1", 1);
					}
				}
			}).error(function(jqXHR, textStatus, errorThrown) {
				console.log("error " + textStatus);
				console.log("error Details " + errorThrown);
				console.log("incoming Text " + jqXHR.responseText);
			});;
			
			// setup form function - Load car & motorcycle attributes
			if ($("#listing-category-id").val() == "60")
			{
				LoadAllCarMakes();
			}
			if ($("#listing-category-id").val() == "67")
			{
				LoadAllMotorMakes();
			}	
			else if ($("#listing-category-id").val() == "80")
			{
				LoadAllCustomMakes('TruckNBus');		
			}	
			else if ($("#listing-category-id").val() == "600")
			{
				LoadAllCustomMakes('VintageClassic');
			}
			else if ($("#listing-category-id").val() == "601")
			{
				LoadAllCustomMakes('HotCustom');
			}
			
			ReloadImages();
			
			$("#ReloadImage").click(function(e){
				ReloadImages();
			});
	
			$("#ResetCat").click(function(e){
				$(".CatSelected").hide();	
				$("#CatSelection").show();
				
				$("#CustomAttribute").empty();
				
				$(".AutomotiveListingTemplateSelected").hide();	
				$(".AutomotiveListingTemplate").hide();	
				
				$("#CustomMakeModelListing").hide();	
				$(".CustomMakeModelListingTemplateSelected").hide();
				
				$(".MotorcycleListingTemplateSelected").hide();	
				$(".MotorcycleListingTemplate").hide();	
				
				$(".GMListingTemplate").hide();	
				
				$(".AutomotiveListingAddInfo").hide();	
				
				$("#reset-car-attr").val("true");	
				
				$('#listing-title').val('');
				$('#listing-title').prop('readonly', false);
				e.preventDefault();
			});
			
			VINRegNoValidation();
			
			$("#listing-vehicle-registered").click(function(e){
				VINRegNoValidation();
			});
			
			$("#listing-vehicle-VinEngine").change(function() {
  				var VinEngine = $('#listing-vehicle-VinEngine option:selected').val();
				if (VinEngine == "VIN")
				{
					$("#listing-vehicle-VinEngine-VIN").show();
					
					$("#listing-vehicle-VinEngine-Engine").val('');
					$("#listing-vehicle-VinEngine-Engine").hide();
					$("#listing-vehicle-VinEngine-Engine").removeClass("error");
					$("#listing-vehicle-VinEngine-Engine").next("label").remove();
				}
				else
				{
					$("#listing-vehicle-VinEngine-Engine").show();
					
					$("#listing-vehicle-VinEngine-VIN").val('');
					$("#listing-vehicle-VinEngine-VIN").hide();
					$("#listing-vehicle-VinEngine-VIN").removeClass("error");
					$("#listing-vehicle-VinEngine-VIN").next("label").remove();
					
				}
			});
			
			
			//=================================================================
			// Show/Hide Price qualifier
			//=================================================================
			PricingLoad();
			
			
			//=================================================================
			// Contact level
			//=================================================================
			$("#listing-contact-setting").click(function(e){
				if ($("#listing-contact-setting").prop('checked'))
				{
					$("#listing-level-contact").hide();
					
					$("[name='listing-contact-name']").removeClass("required");
					$("[name='listing-contact-email']").removeClass("required");
					$("[name='listing-contact-phone']").removeClass("required");
				}
				else
				{
					$("#listing-level-contact").show();
					
					$("[name='listing-contact-name']").addClass("required");
					$("[name='listing-contact-email']").addClass("required");
					$("[name='listing-contact-phone']").addClass("required");
				}
			});
			//=================================================================
			
			$("#checkout").click(function(e){
				$("#IsPostBack").val("false");
				$("#PublishListing").val("false");
				$("#CheckoutListing").val("true");
				
				FieldValidation();
				
				ResetCatAttr();
				
				LocationValidation(e);
			});
			
			$("#publish").click(function(e){
				$("#IsPostBack").val("false");
				$("#PublishListing").val("true");
				$("#CheckoutListing").val("false");
				
				FieldValidation();
				
				ResetCatAttr();
				
				LocationValidation(e);
			});
			
			$("#submit").click(function(e){
				$("#IsPostBack").val("true");
				$("#PublishListing").val("false");
				$("#CheckoutListing").val("false");
				
				FieldValidation();
				
				ResetCatAttr();
				
				LocationValidation(e);
				
				/*if (LocationValidation() == undefined || LocationValidation() == false ){
					e.preventDefault();
				}*/
			});
						
			$('#listing-location').typeahead({
				source: function (query, process) {
					
					// Add load status
					var $self = this.$element;
					$self.css({
						background:'url(/media/1111/ajax-loader.gif) no-repeat 95% center'
					});
					
					// Remove load status on blur
					$self.on('blur.load-status',function(){ 
						$(this).css('background','none'); 
						
					});
					
					// Data source
					return $.getJSON(
						'/api?api=LocSearch&query=' + query,
						function (data) {
							if (data.State == 1) {
								$self.css('background','none');
								var LocInfo = jQuery.parseJSON(data.Result);
								console.log(LocInfo);
								return process(LocInfo);
							}	
						});
				},
				
				// Highlight typed in result
				highlighter: function (item) {
					var regex = new RegExp( '(' + this.query + ')', 'gi' );
					return item.replace( regex, "<strong>$1</strong>" );
				}
			});
		});

		//=================================================================
		// Show/Hide Price qualifier
		//=================================================================

		var AutoPriceDescOptions = {
			'' : 'Select an option',
			'Negotiable' : 'Negotiable',
			'DriveAway' : 'Drive Away',
			'Unqualified' : '(Excl. Govt Charges)',
			'Sale' : 'Sale Price',
			'RRP' : 'RRP'
		};
		
		var GMPriceDescOptions = {
			'' : 'Select an option',
			'Negotiable' : 'Negotiable',
			'Starting Price' : 'Starting Price',
			'Reserve Price' : 'Reserve Price',
			'Sale Price' : 'Sale Price',
			'RRP' : 'RRP'
		};
		
		var FreePriceDescOptions = {
			'Call for Price' : 'Call for Price',
			'Swap/Trade' : 'Swap/Trade',
			'Free' : 'Free'
		};

		function RemoveVINRegNoValidation()
		{
			$("#listing-vehicle-rego").removeClass("required");
			$("#listing-vehicle-rego").removeClass("error");
			
			$("#listing-vehicle-VIN").removeClass("required");
			$("#listing-vehicle-VIN").removeClass("error");
			
			$("#listing-vehicle-VinEngine-Engine").removeClass("required");
			$("#listing-vehicle-VinEngine-Engine").removeClass("error");
			
			$("#listing-vehicle-VinEngine-VIN").removeClass("required");
			$("#listing-vehicle-VinEngine-VIN").removeClass("error");
		}

		function VINRegNoValidation()
		{
			if ($("#listing-vehicle-registered").prop('checked'))
			{
				$(".VehicleRegistered").show();
				$(".VehicleNotRegistered").hide();
				
				$("#listing-vehicle-rego").addClass("required");
				
				// Remove validation on not registered page
				$("#listing-vehicle-VinEngine-Engine").removeClass("required");
				$("#listing-vehicle-VinEngine-Engine").val('');
				$("#listing-vehicle-VinEngine-Engine").hide();
				$("#listing-vehicle-VinEngine-Engine").removeClass("error");
				$("#listing-vehicle-VinEngine-Engine").next("label").remove();
				
				$("#listing-vehicle-VinEngine-VIN").removeClass("required");
				$("#listing-vehicle-VinEngine-VIN").val('');
				$("#listing-vehicle-VinEngine-VIN").hide();
				$("#listing-vehicle-VinEngine-VIN").removeClass("error");
				$("#listing-vehicle-VinEngine-VIN").next("label").remove();
			}
			else
			{
				$(".VehicleNotRegistered").show();
				$(".VehicleRegistered").hide();
				
				$("#listing-vehicle-VinEngine").val('VIN');
				$("#listing-vehicle-VinEngine-VIN").addClass("required");
				$("#listing-vehicle-VinEngine-VIN").show();
				
				// Remove validation on registered page
				$("#listing-vehicle-rego").val('');
				$("#listing-vehicle-rego").removeClass("required");
				$("#listing-vehicle-rego").removeClass("error");
				$("#listing-vehicle-rego").next("label").remove();
				
				$("#listing-vehicle-VIN").val('');
				$("#listing-vehicle-VIN").removeClass("required");
				$("#listing-vehicle-VIN").removeClass("error");
				$("#listing-vehicle-VIN").next("label").remove();
			}
	
		}

		function PricingLoad()
		{
			var IsRetailUser = false;
			if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
			
			// Show has price selection to commercial customer only
			if (IsRetailUser)
			{
				$("#listing-has-pricing").hide();
			}
			else
			{
				$("#listing-has-pricing").show();
				PopulatePriceDropdown(GMPriceDescOptions);
			}
			
			$("#listing-has-price").click(function(e){
				PricingStructureChanged();
			});		
			
			// Default selection for price entry
			$("#listing-driveaway-price").blur(function(e){
				PriceChanged();
			});
			$("#listing-sale-price").blur(function(e){
				PriceChanged();
			});
			$("#listing-unqualified-price").blur(function(e){
				PriceChanged();
			});
		}

		function PriceChanged()
		{
			var DriveAwayPrice = $("#listing-driveaway-price").val();
			var SalePrice = $("#listing-sale-price").val();
			var UnqualifiedPrice = $("#listing-unqualified-price").val();
			
			var PriceDesc = "";
			if (DriveAwayPrice != "")
			{
				PriceDesc = "DriveAway";
			}
			
			if (SalePrice != "" && DriveAwayPrice == "")
			{
				PriceDesc = "Sale";
			}
			
			if (UnqualifiedPrice != "" && SalePrice == "" && DriveAwayPrice == "")
			{
				PriceDesc = "Unqualified";
			}
			
			if (PriceDesc != "")
			{
				$("#listing-price-qualifier").removeAttr('disabled');
				
				if (PriceDesc == "DriveAway")
				{
					$("#listing-price-qualifier").val(PriceDesc);
					$("#listing-price-qualifier").attr('disabled','disabled');
				}
				else
				{
					$("#listing-price-qualifier").val(PriceDesc);
				}
			}
		}

		function PricingStructureChanged()
		{		
			$("#listing-price-qualifier").removeAttr('disabled');
			
			var IsRetailUser = false;
			if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
			if (IsRetailUser) return; // Not Applicable for retail user
			
			var CatID = $("#listing-category-id").val();
			if ($("#listing-has-price").prop('checked'))
			{
				//Cars (60), Vintage (600), Hotrod (601), Motorbikes (67), truck and buss (80)
				if (CatID == '60' || CatID == '600' || CatID == '601' || CatID == '67' || CatID == '80')
				{
					PopulatePriceDropdown(AutoPriceDescOptions);	
					CustomPricing(true);
				}
				else
				{
					PopulatePriceDropdown(GMPriceDescOptions);	
					CustomPricing(false);
				}
			}
			else
			{
				$("#custom-pricing").hide();
				$("#standard-pricing").hide();
				
				PopulatePriceDropdown(FreePriceDescOptions);
				
				$("#listing-driveaway-price").val('');
				$("#listing-sale-price").val('');
				$("#listing-unqualified-price").val('');
				$("#listing-price").val('');
			}
		}

		function PopulatePriceDropdown(PriceDescOptions)
		{
			// Add drop down
			var PriceDescControl = $("#listing-price-qualifier");
			PriceDescControl.empty();
			$.each(PriceDescOptions, function(val, text) {
				PriceDescControl.append(
					$('<option></option>').val(val).html(text)
				);
			});
		}

		//=================================================================
		
		function FieldValidation()
		{
			//--------------------------------------
			// Required field Validation
			
			$("#listing-location").addClass("required");
			$("#listing-title").addClass("required");
			$("#listing-summary").addClass("required");
			$("#listing-description-wysiwyg").addClass("required");
			
			// Price validation
			// Check if is business user
			var IsRetailUser = false;
			if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
			
			if (IsRetailUser)
			{
				$("#listing-price").addClass("required");
				$("#listing-driveaway-price").removeClass("required");
			}
			else
			{
				// Required field for commercial user
				$("[name='listing-stock-number']").addClass("required");
				
				if ($("#standard-pricing").is(":visible")) 
				{
					// handle non visible state
					$("#listing-price").addClass("required");
					$("#listing-driveaway-price").removeClass("required");
				}
				else
				{
					// Check if has price checked
					if ($("#listing-has-price").prop('checked'))
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
					else
					{
						$("#listing-price").removeClass("required");
						$("#listing-driveaway-price").removeClass("required");
					}
				}
    		
			}
			
			var UIEditorLink = $("#UIEditorLink").val();
			if (UIEditorLink == "MotorcycleListing" || UIEditorLink == "AutomotiveListing")
			{
				if ($("#listing-vehicle-registered").prop('checked'))
				{
					$("#listing-vehicle-rego").removeClass("required");
					$("#listing-vehicle-rego").removeClass("error");
										
					if (($("#listing-vehicle-rego").val() == '' || $("#listing-vehicle-rego").val() == undefined ) &&
						($("#listing-vehicle-VIN").val() == '' || $("#listing-vehicle-VIN").val() == undefined )
					    )
					{
						$("#listing-vehicle-rego").addClass("required");
						$("#listing-vehicle-rego").addClass("error");
						alertModal('Please enter either Rego or Vin #.','Error','warning');
					}
					
					$("#listing-vehicle-VinEngine").removeClass("required");
					
					$("#listing-vehicle-VinEngine-Engine").val('');
					$("#listing-vehicle-VinEngine-Engine").hide();
					$("#listing-vehicle-VinEngine-Engine").removeClass("required");
					$("#listing-vehicle-VinEngine-Engine").removeClass("error");
					$("#listing-vehicle-VinEngine-Engine").next("label").remove();
					
					$("#listing-vehicle-VinEngine-VIN").val('');
					$("#listing-vehicle-VinEngine-VIN").hide();
					$("#listing-vehicle-VinEngine-VIN").removeClass("required");
					$("#listing-vehicle-VinEngine-VIN").removeClass("error");
					$("#listing-vehicle-VinEngine-VIN").next("label").remove();
				}
				else
				{
					$("#listing-vehicle-rego").removeClass("required");
					$("#listing-vehicle-rego").removeClass("error");
					
					$("#listing-vehicle-VinEngine").addClass("required");
					
					var VinEngineType = $('#listing-vehicle-VinEngine option:selected').val();
					if (VinEngineType == "VIN")
					{
						$("#listing-vehicle-VinEngine-VIN").addClass("required");
						$("#listing-vehicle-VinEngine-Engine").removeClass("required");
						
						if ($("#listing-vehicle-VinEngine-VIN").val() == '' || $("#listing-vehicle-VinEngine-VIN").val() == undefined )
						{
							$("#listing-vehicle-VinEngine-VIN").addClass("error");
							alertModal('Please enter VIN# (17 characters with no space)','Error','warning');
						}
					}
					else
					{
						$("#listing-vehicle-VinEngine-Engine").addClass("required");
						$("#listing-vehicle-VinEngine-VIN").removeClass("required");
						
						if ($("#listing-vehicle-VinEngine-Engine").val() == '' || $("#listing-vehicle-VinEngine-Engine").val() == undefined )
						{
							$("#listing-vehicle-VinEngine-Engine").addClass("error");
							alertModal('Please enter Engine #.','Error','warning');
						}
					}	
	            }

	            if ($("#listing-odometer-value").val() != undefined && $("#listing-odometer-value").val() != "" && $("#listing-odometer-value").val() != "0") {
	                $("#listing-odometer-unit").addClass("required");
	            }
			}
			else
			{
				RemoveVINRegNoValidation();
			}
			
			if ($("#reset-car-attr").val() == "false") return;
			
			if ($("#listing-category-id").val() == undefined || $("#listing-category-id").val() == "")
			{
				$("#CatLvl1").addClass("required");
			}else
			{
				$("#CatLvl1").removeClass("required");
			}
			
			
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

					$("#listing-odometer-unit").removeClass("required");

					break;

	            case "AutomotiveListing":

	                var CatID = $("#listing-category-id").val();

	                // Truck and bus, Hot rods, Vintage car
	                if (CatID == 80 || CatID == 600 || CatID == 601) {
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
	                else {
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
				//$("#listing-variant").val($("#easylist-Variant option:selected").text().trim());
				
				$("#listing-motor-make").val($("#easylist-Motor-Makes option:selected").val().trim());
				$("#listing-motor-model").val($("#easylist-Motor-Models option:selected").val().trim());
				$("#listing-motor-year").val($("#easylist-Motor-Years option:selected").val().trim());
				//$("#listing-motor-variant").val($("#easylist-Motor-Variant option:selected").val().trim());
				
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
			
			var ImgRotateURL="/api?api=NewImageToRotate&UserCode=" + UserCode + "&UserTempKey=" + UserTempKey + "&ImgCode=" + ImgCode;
						
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
					'<a href="' + ImgRotateURL + '&imgRotation=Left" class="rotate-image-left IsNew" data-image-id="'+ ImgCode+ '" title="Rotate Left">' +
						'<i class="icon-undo-2"></i>' +
					'</a>' +
					'<a href="' + ImgRotateURL + '&imgRotation=Right" class="rotate-image-right IsNew" data-image-id="' + ImgCode + '" title="Rotate Right">' +
						'<i class="icon-redo-2"></i>' +
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
		