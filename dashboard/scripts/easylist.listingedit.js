
		function FixAutoSpec(Make, Model, Year, Series, StyleType, Style, TransType, Transmission, Variant, AutoVariantInfo, Title, OverwriteStdFeaturesList, StdFeaturesList, OptFeaturesList)
		{
			$("#listing-auto-make").val(Make);
			$("#listing-auto-model").val(Model);
			$("#listing-auto-series").val(Series);
			$("#listing-auto-year").val(Year);
			
			$('#listing-auto-body-style').val(StyleType);			
			$("#listing-auto-body-style-description").val(Style);
			
			$("#listing-auto-transmission-type").val(TransType);
			$("#listing-auto-transmission-description").val(Transmission);
			$("#listing-auto-variant").val(Variant);
			
			if (AutoVariantInfo != null)
			{
				if (AutoVariantInfo.NoOfDoors != "")
				{
					$("[name='listing-doors']").val(AutoVariantInfo.NoOfDoors);
					TriggerLock("[name='listing-doors']");
				}
				
				if (AutoVariantInfo.NoOfSeats != "")
				{
					$("[name='listing-seats']").val(AutoVariantInfo.NoOfSeats);
					TriggerLock("[name='listing-seats']");
				}
				
				if (AutoVariantInfo.DriveType != "")
				{
					$("[name='listing-drive-type']").val(AutoVariantInfo.DriveType);
					TriggerLock("[name='listing-drive-type']");
				}
				
				if (AutoVariantInfo.Cylinder != "")
				{
					$("[name='listing-engine-cylinders']").val(AutoVariantInfo.Cylinder);
					TriggerLock("[name='listing-engine-cylinders']");
				}
				
				if (AutoVariantInfo.Engine != "")
				{
					$("[name='listing-engine-type-description']").val(AutoVariantInfo.Engine);
					TriggerLock("[name='listing-engine-type-description']");
				}
				
				if (AutoVariantInfo.EngineSize != "")
				{
					$("[name='listing-engine-size-description']").val(AutoVariantInfo.EngineSize);
					TriggerLock("[name='listing-engine-size-description']");
				}
				
				if (AutoVariantInfo.FuelType != "")
				{
					$("[name='listing-fuel-type-description']").val(AutoVariantInfo.FuelType);
					TriggerLock("[name='listing-fuel-type-description']");
				}
				
				if (AutoVariantInfo.NVIC != "")
				{
					$("[name='listing-nvic']").val(AutoVariantInfo.NVIC);
				}
			}			
			
			$("#listing-title").val(Title);
			
			$("#listing-has-exception").val('false');
			
			TriggerLock('#listing-title');
			TriggerLock('#listing-auto-body-style');
			TriggerLock('#listing-auto-body-style-description');
			TriggerLock('#listing-auto-transmission-type');
			TriggerLock('#listing-auto-transmission-description');
			
			TriggerLock('.FeaturesLock');
						
			if (OverwriteStdFeaturesList && (StdFeaturesList != ""))
			{
				$('#standard-features').empty();
				var sfItems = [];
				var StandardFeaturesNameArray = StdFeaturesList.split('|');
				for (var i = 0; i < StandardFeaturesNameArray.length; i++) {
					if (StandardFeaturesNameArray[i] != "") {
						sfItems.push('<li data-id="' + i+1 + '">' 
						+ '<a href="#" class="select-item-delete btn btn-small btn-info" data-id="' + i+1 + '">'
						+ '<i class="icon-remove"></i>'
						+ '</a>&nbsp;<span>' + StandardFeaturesNameArray[i] + '</span>'
						+ '</li> ');
                     }
				}
				if (sfItems.length > 0) {
                     $('#standard-features').html(sfItems.join(''));
					 $('#listing-standard-features').val(StdFeaturesList);
                 }
			}
			
			$('form').not('.no-change-tracking').addClass('has-changes');
			
			$.magnificPopup.close();
		}

		function FixMotorSpec(Make, Model, Year, Variant, Series, BodyDesc, TrmDesc, EngCylinders, EngDesc, EngSizeDesc, NVIC, Title, OverwriteStdFeaturesList, StdFeaturesList)
		{
			$("#listing-motor-make").val(Make);
			$("#listing-motor-model").val(Model);
			$("#listing-motor-year").val(Year);
			
			$("#listing-motor-variant").val(Variant);
			$("#listing-motor-series").val(Series);
			
			$("#listing-motor-body-style-description").val(BodyDesc);
			$("#listing-motor-transmission-description").val(TrmDesc);
			$("#listing-motor-engine-cylinders").val(EngCylinders);
			$("#listing-motor-engine-description").val(EngDesc);
			$("#listing-motor-engine-size-description").val(EngSizeDesc);
			
			$("#listing-title").val(Title);
			
			$("#listing-has-exception").val('false');
			
			if (NVIC != "")
			{
				$("[name='listing-nvic']").val(NVIC);
			}
			
			TriggerLock('#listing-title');
			
			TriggerLock('#listing-motor-body-style-description');
			TriggerLock('#listing-motor-transmission-description');
			TriggerLock('#listing-motor-engine-cylinders');
			TriggerLock('#listing-motor-engine-description');
			TriggerLock('#listing-motor-engine-size-description');
			
			TriggerLock('.FeaturesLock');
						
			if (OverwriteStdFeaturesList && (StdFeaturesList != ""))
			{
				$('#standard-features').empty();
				var sfItems = [];
				var StandardFeaturesNameArray = StdFeaturesList.split('|');
				for (var i = 0; i < StandardFeaturesNameArray.length; i++) {
					if (StandardFeaturesNameArray[i] != "") {
						sfItems.push('<li data-id="' + i+1 + '">' 
						+ '<a href="#" class="select-item-delete btn btn-small btn-info" data-id="' + i+1 + '">'
						+ '<i class="icon-remove"></i>'
						+ '</a>&nbsp;<span>' + StandardFeaturesNameArray[i] + '</span>'
						+ '</li> ');
                     }
				}
				if (sfItems.length > 0) {
                     $('#standard-motor-features').html(sfItems.join(''));
					 $('#listing-motor-standard-features').val(StdFeaturesList);
                 }
			}
			
			$('form').not('.no-change-tracking').addClass('has-changes');
			
			$.magnificPopup.close();
		}

		function TriggerLock(UpdCtrlName)
		{
			var label = $(UpdCtrlName).parent().find('.lock-label').not('.locked');
			$(label).addClass('locked').find('input').attr('checked', 'checked');
		}

		function CancelPopup()
		{
			$.magnificPopup.close();
		}

		$(document).ready(function () {
		    $.metadata.setType('attr', 'data-validate');
		    $('.form-horizontal').each(function () {
		        $(this).validate();
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
				
		    /* $("#listing-price").maskMoney();
		    $("#listing-was-price").maskMoney();
		    $("#listing-driveaway-price").maskMoney();
		    $("#listing-sale-price").maskMoney();
		    $("#listing-unqualified-price").maskMoney();*/
			
			$('#listing-price').autoNumeric('init');
			$('#listing-was-price').autoNumeric('init');
			$('#listing-driveaway-price').autoNumeric('init');
			$('#listing-sale-price').autoNumeric('init');
			$('#listing-unqualified-price').autoNumeric('init');

		    $('#FixListingCarSpec').on('click', function (e) {

		        var Make = $('#listing-auto-make').val();
		        var Model = $('#listing-auto-model').val();
		        var Year = $('#listing-auto-year').val();
		        var Style = $('#listing-auto-body-style-description').val();
		        var Transmission = $('#listing-auto-transmission-description').val();
		        var Variant = $('#listing-auto-variant').val();
		        var Title = $('#listing-title').val();

		        // Open the popup to upload images
		        $.magnificPopup.open({
		            items: {
		                src: "/listingspec?CatID=60&" + "&Make=" + Make + "&Model=" + Model + "&Year=" + Year + "&Style=" + Style + "&Transmission=" + Transmission + "&Variant=" + Variant + "&Title=" + Title
		            },
		            type: 'iframe',
		            overflowY: 'scroll',
		            alignTop: true,
		            mainClass: 'mfp-full-height',
		            callbacks: {
		                close: function () {
		                    //alert($("#listing-catalog").val());
		                }
		            }
		        });
		    });

		    $('#FixListingMotorSpec').on('click', function (e) {

		        var Make = $('#listing-motor-make').val();
		        var Model = $('#listing-motor-model').val();
		        var Year = $('#listing-motor-year').val();

		        var Variant = $('#listing-motor-variant').val();

		        var regex = new RegExp('"', 'g');
		        Variant = Variant.replace(regex, '|');

		        var Title = $('#listing-title').val();

		        // Open the popup to upload images
		        $.magnificPopup.open({
		            items: {
		                src: "/listingspec?CatID=67&" + "&Make=" + Make + "&Model=" + Model + "&Year=" + Year + "&Variant=" + Variant + "&Title=" + Title
		            },
		            type: 'iframe',
		            overflowY: 'scroll',
		            alignTop: true,
		            mainClass: 'mfp-full-height',
		            callbacks: {
		                close: function () {
		                    //alert($("#listing-catalog").val());
		                }
		            }
		        });
		    });

		    //=================================================================
		    // Show/Hide Price qualifier
		    //=================================================================
		    PricingLoad();

		    //=================================================================
		    // Contact level
		    //=================================================================
		    $("#listing-contact-setting").click(function (e) {
		        if ($("#listing-contact-setting").prop('checked')) {
		            $("#listing-level-contact").hide();

		            $("[name='listing-contact-name']").removeClass("required");
		            $("[name='listing-contact-email']").removeClass("required");
		            $("[name='listing-contact-phone']").removeClass("required");
		        }
		        else {
		            $("#listing-level-contact").show();

		            $("[name='listing-contact-name']").addClass("required");
		            $("[name='listing-contact-email']").addClass("required");
		            $("[name='listing-contact-phone']").addClass("required");
		        }
		    });
		    //=================================================================

		    UserCodeCatalog();

		    //-----------------------------------------------------------------
		    // User Catalog List
		    //-----------------------------------------------------------------
		    $("#listing-usercode").change(function (e) {
		        UserCodeCatalog();
		    });

		    $("#listing-catalog").change(function (e) {
		        CatalogChanged();
		    });

			
			//--------------Render FeedDestinationDynamically Start-------------
			function InitialiseFeedOut() {
			//==============================================================================
			// Initialise feed out destination list, uncheck and hide all
			   $("div[id^='DIV-FeedDest-']").hide();
			   $("input[id^='listing-publish-dest']").prop('checked', false);
			//==============================================================================
			}

			function CatalogChanged() {
				var Catalog = $('#listing-catalog option:selected').val();
				var CatalogFeedDestination = $('#listing-catalog option:selected').attr('data-feeddestination');
			
				var CurrentFeedOutList = $('#listing-FeedOutDestList').val();
			
				InitialiseFeedOut();
			
				var FeedOutDestList = CatalogFeedDestination.split(",");
				for (var i = 0; i < FeedOutDestList.length; i++) {
					var FeedOutDest = FeedOutDestList[i];
			
					$('#DIV-FeedDest-' + FeedOutDest).show();
			
					if (CurrentFeedOutList.indexOf(FeedOutDest) != -1) {
						$('#listing-publish-dest-' + FeedOutDest).prop('checked', true);
					}
				}
			}

			function UserCodeCatalog() {
				var UserCode = $('#listing-usercode option:selected').val();
				var CatalogData = $('#listing-usercode option:selected').attr('data-catalog');
				var CurrentFeedOutList = $('#listing-FeedOutDestList').val();
			
				if (CatalogData != "" && CatalogData != "[]" && CatalogData != undefined) {
					var CatalogObj = jQuery.parseJSON(CatalogData);
			
					var SelectControlDiv = "<div class='control-group'><label class='control-label'>Catalog</label>" +
							"<div class='controls'>";
					SelectControlDiv += "<select class='drop-down required' id='listing-catalog' name='listing-catalog'>";
			
					//==============================================================================
					// Initialise feed out destination list, uncheck and hide all
					InitialiseFeedOut();
					//==============================================================================
			
					$.each(CatalogObj, function (key, catalog) {
						//alert(catalog.ID);
			
						var Selected = "";
			
						if (catalog.Selected == "1") {
							Selected = "selected='selected'";
			
							//==============================================================================
							// Feed Out Destination List
							if (catalog.FeedDestinationList) {
								var FeedOutDestList = catalog.FeedDestinationList.split(",");
								for (var i = 0; i < FeedOutDestList.length; i++) {
									var FeedOutDest = FeedOutDestList[i];
			
									$('#DIV-FeedDest-' + FeedOutDest).show();
			
									if (CurrentFeedOutList.indexOf(FeedOutDest) != -1) {
										$('#listing-publish-dest-' + FeedOutDest).prop('checked', true);
									}
								}
							}
							//==============================================================================
						}
						SelectControlDiv += "<option value='" + catalog.ID + "' " + Selected + " data-feedDestination='" + catalog.FeedDestinationList + "' >" + catalog.Name + "</option>";
					});
			
					SelectControlDiv += "</select>";
					SelectControlDiv += "</div></div>";
			
					$('.listingCatalog').html(SelectControlDiv);
					$('.listingCatalog').show();
			
					$("#listing-catalog").change(function (e) {
						CatalogChanged();
					});
			
					$("#listing-catalog").change();
			
				} else {
					$('.listingCatalog').empty();
					$('.listingCatalog').hide();
				}
			}
			
			/* 
		    function InitialiseFeedOut() {
		        //==============================================================================
		        // Initialise feed out destination list, uncheck and hide all
		        //$('#DIV-TradingPost').hide();
		        $('#DIV-UniqueWebsites').hide();
		        $('#DIV-Carsguide').hide();
		        $('#DIV-DealerSolutions').hide();
		        $('#DIV-Gumtree').hide();
		        $('#DIV-Ebay').hide();
		        $('#DIV-JustAutos').hide();
		        $('#DIV-Carsales').hide();
		        $('#DIV-MyCarAds').hide();

		        //$('#listing-publish-dest-TradingPost').prop('checked', false);
		        $('#listing-publish-dest-UniqueWebsites').prop('checked', false);
		        $('#listing-publish-dest-Carsguide').prop('checked', false);
		        $('#listing-publish-dest-DealerSolutions').prop('checked', false);
		        $('#listing-publish-dest-Gumtree').prop('checked', false);
		        $('#listing-publish-dest-Ebay').prop('checked', false);
		        $('#listing-publish-dest-JustAutos').prop('checked', false);
		        $('#listing-publish-dest-Carsales').prop('checked', false);
		        $('#listing-publish-dest-MyCarAds').prop('checked', false);

		        //==============================================================================
		    }

		    function CatalogChanged() {
		        var Catalog = $('#listing-catalog option:selected').val();
		        var CatalogFeedDestination = $('#listing-catalog option:selected').attr('data-feeddestination');

		        var CurrentFeedOutList = $('#listing-FeedOutDestList').val();

		        InitialiseFeedOut();

		        var FeedOutDestList = CatalogFeedDestination.split(",");
		        for (var i = 0; i < FeedOutDestList.length; i++) {
		            var FeedOutDest = FeedOutDestList[i];

		            $('#DIV-' + FeedOutDest).show();

		            if (CurrentFeedOutList.indexOf(FeedOutDest) != -1) {
		                $('#listing-publish-dest-' + FeedOutDest).prop('checked', true);
		            }
		        }
		    }

		    function UserCodeCatalog() {
		        var UserCode = $('#listing-usercode option:selected').val();
		        var CatalogData = $('#listing-usercode option:selected').attr('data-catalog');
		        var CurrentFeedOutList = $('#listing-FeedOutDestList').val();

		        if (CatalogData != "" && CatalogData != "[]" && CatalogData != undefined) {
		            var CatalogObj = jQuery.parseJSON(CatalogData);

		            var SelectControlDiv = "<div class='control-group'><label class='control-label'>Catalog</label>" +
							"<div class='controls'>";
		            SelectControlDiv += "<select class='drop-down required' id='listing-catalog' name='listing-catalog'>";

		            //==============================================================================
		            // Initialise feed out destination list, uncheck and hide all
		            InitialiseFeedOut();
		            //==============================================================================

		            $.each(CatalogObj, function (key, catalog) {
		                //alert(catalog.ID);

		                var Selected = "";

		                if (catalog.Selected == "1") {
		                    Selected = "selected='selected'";

		                    //==============================================================================
		                    // Feed Out Destination List
		                    if (catalog.FeedDestinationList) {
		                        var FeedOutDestList = catalog.FeedDestinationList.split(",");
		                        for (var i = 0; i < FeedOutDestList.length; i++) {
		                            var FeedOutDest = FeedOutDestList[i];
									
		                            $('#DIV-' + FeedOutDest).show();

		                            if (CurrentFeedOutList.indexOf(FeedOutDest) != -1) {
		                                $('#listing-publish-dest-' + FeedOutDest).prop('checked', true);
		                            }
		                        }
		                    }
		                    //==============================================================================
		                }
		                SelectControlDiv += "<option value='" + catalog.ID + "' " + Selected + " data-feedDestination='" + catalog.FeedDestinationList + "' >" + catalog.Name + "</option>";
		            });

		            SelectControlDiv += "</select>";
		            SelectControlDiv += "</div></div>";

		            $('.listingCatalog').html(SelectControlDiv);
		            $('.listingCatalog').show();

		            $("#listing-catalog").change(function (e) {
		                CatalogChanged();
		            });

		            $("#listing-catalog").change();

		        } else {
		            $('.listingCatalog').empty();
		            $('.listingCatalog').hide();
		        }
		    } */
			//--------------Render FeedDestinationDynamically End-------------
			
			

		    //-----------------------------------------------------------------
		    // Set condition
		    //-----------------------------------------------------------------
		    var ConditionLock = $('#lock-condition').prop("checked");

		    // setup form functions - Listing condition logic
		    $(".listing-condition").change(function (e) {
		        if ($('.listing-condition option:selected').val() == 'New' || $('.listing-condition option:selected').val() == '') {
		            $(".listing-condition-desc").hide();
		            $(".listing-condition-desc").removeClass("required");
		        } else {
		            $(".listing-condition-desc").show();
		            $(".listing-condition-desc").addClass("required");
		        }
		    });

		    if (ConditionLock == true) {
		        $('#lock-condition').parent('label').addClass('locked').attr('title', 'This field is locked, so the original data sync source can no longer overwrite it.');
		    }
		    else {
		        $('#lock-condition').parent('label').removeClass('locked').attr('title', 'This field is unlocked, and may be overritten when data next syncs.');
		    }

		    $('.form-horizontal').removeClass('has-changes');

		    // Move error to last place to avoid breaking lock label
		    function updateError(parent) {
		        var error = $('label.error', parent).remove();
		        if (error) { $(parent).append(error); }
		    }
		    function updateErrors(form) {
		        $('.controls', form).each(function () {
		            updateError(this)
		        });
		    }

		    function Rego() {
		        // Additional info for motorcyle and car
		        /*if ($("#listing-vehicle-registered").prop('checked')) {
					
					$("#listing-vehicle-rego").removeClass("required");
					if (($("#listing-vehicle-rego").val() == '' || $("#listing-vehicle-rego").val() == undefined ) &&
						($("#listing-vehicle-VIN").val() == '' || $("#listing-vehicle-VIN").val() == undefined )
					    )
					{
						$("#listing-vehicle-rego").addClass("required");
						alertModal('Please enter either Rego or Vin #.','Error','warning');
					}
					
		            $("#listing-vehicle-VinEngine").removeClass("required");
		            $("#listing-vehicle-VinEngine-No").removeClass("required");
		        } else {
		            $("#listing-vehicle-rego").removeClass("required");
		            
		            $("#listing-vehicle-VinEngine").addClass("required");
		            $("#listing-vehicle-VinEngine-No").addClass("required");
		        }*/
				
				if ($("#listing-vehicle-registered").prop('checked'))
				{
					$("#listing-vehicle-rego").removeClass("required");
					if (($("#listing-vehicle-rego").val() == '' || $("#listing-vehicle-rego").val() == undefined ) &&
						($("#listing-vehicle-VIN").val() == '' || $("#listing-vehicle-VIN").val() == undefined )
					    )
					{
						$("#listing-vehicle-rego").addClass("required");
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
					$("#listing-vehicle-VIN").val('');
					$("#listing-vehicle-VIN").removeClass("required");
					$("#listing-vehicle-VIN").removeClass("error");
					$("#listing-vehicle-rego").removeClass("required");
					$("#listing-vehicle-rego").removeClass("error");
					$("#listing-vehicle-VinEngine").addClass("required");
					
					var VinEngineType = $('#listing-vehicle-VinEngine option:selected').val();
					if (VinEngineType == "VIN")
					{
						$("#listing-vehicle-VinEngine-VIN").show();
						$("#listing-vehicle-VinEngine-VIN").addClass("required");
						
						$("#listing-vehicle-VinEngine-Engine").val('');
						$("#listing-vehicle-VinEngine-Engine").removeClass("required");
						$("#listing-vehicle-VinEngine-Engine").removeClass("error");
					}
					else
					{
						$("#listing-vehicle-VinEngine-Engine").show();
						$("#listing-vehicle-VinEngine-Engine").addClass("required");
						
						$("#listing-vehicle-VinEngine-VIN").val('');
						$("#listing-vehicle-VinEngine-VIN").removeClass("required");
						$("#listing-vehicle-VinEngine-VIN").removeClass("error");
					}	
				}
		    }

		    function SubmitChangeProcess() {
		        Rego();
		    }

		    function LocationValidation(e) {
		        $.ajax({
		            async: false,
		            type: "GET",
		            contentType: "application/json; charset=utf-8",
		            dataType: "json",
		            url: '/api?api=LocInfo&Location=' + $('#listing-location').val(),
		            success: function (data) {
		                if (data.State == 1) {
		                    $("#listing-location").removeClass("error");
		                    $("#listing-location-validator").val("true");
		                    $("#listing-location-validate").hide();
		                    return true;
		                } else {
		                    $("#listing-location").addClass("error");
		                    $("#listing-location-validator").val("false");
		                    $("#listing-location-validate").show();

		                    $('#submit-changes').resetbtnload();
		                    $('#Publish-Ad').resetbtnload();
		                    $('#Extend-Ad').resetbtnload();

		                    e.preventDefault();
		                    return false;
		                }
		            }
		        });
		    }

		    $('.form-horizontal input[type="text"], .form-horizontal textarea').on('keyup blur', function (e) {
		        updateError($(this).parent());
		    });
		    $('.form-horizontal select, .form-horizontal input[type="radio"], .form-horizontal input[type="checkbox"]').on('change', function () {
		        updateError($(this).parent());
		    });

		    $('.form-horizontal').on('submit', function (e) {
		        updateErrors(this)
		        var errors = $('.error', this).filter(function () { return $(this).css('display') != 'none'; });
		        if (errors.length > 0) {
		            // Show 1st error location
		            var errortab = $(errors[0]).parents('.tab-pane').index() + 1;
		            $('.nav-tabs li').removeClass('active');
		            $('.nav-tabs li:nth-child(' + errortab + ')').addClass('active');
		            $('.tab-pane').removeClass('active');
		            $('.tab-pane:nth-child(' + errortab + ')').addClass('active');
		            $(errors[0]).focus();
		        }
		    });

		    $("#submit-changes").click(function (e) {
		        LocationValidation(e);

		        $("#listing-description-wysiwyg").blur();

		        $("#update-listing-state").val("");

		        $("#listing-price-qualifier-orig").val($("#listing-price-qualifier").val());

		        Rego();
		    });

		    $("#Cancel-Ad").click(function (e) {

		        e.preventDefault();
		        var ModalAnswer = "No";
		        confirmModal('Are you sure want to cancel this ad?<br/>Please note that this action is irreversible.',
							 'Cancel ad',
							 function () {
							     ModalAnswer = "Yes";
							     $("#update-listing-state").val("Cancel-Ad");
							     SubmitChangeProcess();
							     $('.form-horizontal').submit();
							 }
							);
		        if (ModalAnswer == "No") {
		            $('#Cancel-Ad').resetbtnload();
		        }
		    });

		    $("#Publish-Ad").click(function (e) {
		        LocationValidation(e);

		        $("#update-listing-state").val("Publish-Ad");
		        SubmitChangeProcess();
		    });

		    $("#Relist-Ad").click(function (e) {
		        LocationValidation(e);

		        $("#update-listing-state").val("Relist-Ad");
		        SubmitChangeProcess();
		    });

		    $("#Sold").click(function (e) {
		        e.preventDefault();
		        var ModalAnswer = "No";
		        confirmModal('Are you sure want to mark this ad as sold?<br/>Please note that this action is irreversible.',
							 'Sold ad',
							 function () {
							     ModalAnswer = "Yes";
							     $("#update-listing-state").val("Sold");
							     SubmitChangeProcess();
							     $('.form-horizontal').submit();
							 }
							);
		        if (ModalAnswer == "No") {
		            $('#Sold').resetbtnload();
		        }
		    });

		    $("#Withdrawn").click(function (e) {
		        e.preventDefault();
		        var ModalAnswer = "No";
		        confirmModal('Are you sure want to mark this ad as withdrawn?<br/>Please note that this action is irreversible.',
							 'Withdrawn ad',
							 function () {
							     ModalAnswer = "Yes";
							     $("#update-listing-state").val("Withdrawn");
							     SubmitChangeProcess();
							     $('.form-horizontal').submit();
							 }
							);
		        if (ModalAnswer == "No") {
		            $('#Withdrawn').resetbtnload();
		        }
		    });

		    $("#Extend-Ad").click(function (e) {
		        LocationValidation(e);

		        $("#update-listing-state").val("Extend-Ad");
		        SubmitChangeProcess();
		    });

		    $("#Sell-Similar").click(function (e) {
		        e.preventDefault();

		        // Check if user have saved listing
		        if ($('#TempListingExists').val() == "true") {
		            var ModalAnswer = "No";
		            confirmModal('We\'ve noticed you have previously saved an ad on Tradingpost. If you continue, your previously saved ad will be discarded. Continue?',
							 'Sell Similar',
							 function () {
							     ModalAnswer = "Yes";
							     window.location = '/listings/create?copyFrom=' + $('#ListingCode').val();
							 }
							);
		            if (ModalAnswer == "No") {
		                $('#Sell-Similar').resetbtnload();
		            }
		        }
		        else {
		            window.location = '/listings/create?copyFrom=' + $('#ListingCode').val();
		        }
		    });

		    $("#listing-vehicle-registered").click(function (e) {
		        if ($("#listing-vehicle-registered").prop('checked')) {
		            $(".VehicleRegistered").show();
		            $("#listing-vehicle-rego").addClass("required");
		            //$("#listing-vehicle-expiry-month").addClass("required");
		            //$("#listing-vehicle-expiry-year").addClass("required");

		            $(".VehicleNotRegistered").hide();
		            $("#listing-vehicle-VinEngine").removeClass("required");
		            $("#listing-vehicle-VinEngine-No").removeClass("required");
		        } else {
		            $(".VehicleRegistered").hide();
		            $("#listing-vehicle-rego").removeClass("required");
		            //$("#listing-vehicle-expiry-month").removeClass("required");
		            //$("#listing-vehicle-expiry-year").removeClass("required");

		            $(".VehicleNotRegistered").show();
		            $("#listing-vehicle-VinEngine").addClass("required");
		            $("#listing-vehicle-VinEngine-No").addClass("required");
		        }
		    });

		    $("#ReloadImage").click(function (e) {
		        var ListingCode = getURLParam("listing");
		        $("#manage-images").load("/listings/edit?listing=" + ListingCode + " #manage-images",
										 function (responseText, textStatus, XMLHttpRequest) {
										     if (textStatus == "success") {
										         // all good!
										         //$('.lightbox').colorbox();
										         initImageLightbox();
										         updatePhotoIndexes();
										         updatePhotoCaptions();
										         initImageSorting();
										         InitialiseImageUpload();
										     }
										     if (textStatus == "error") {
										         // oh noes!
										     }
										 });
		        $("#photosCount").empty();
		        $("#photosCount").removeClass();

		        $("#photosCount").load("/listings/edit?listing=" + ListingCode + " #photosCount");
		        checkImageLimit();
		        e.preventDefault();
		    });

		    // Disable [readonly] form for unprivilage users
		    if ($('#ListingViewOnly').length > 0) {
		        $('.widget-content').readonlyForm();
		        $('.ui-sortable').sortable({ disabled: true });
		        $('.thumbnail').css({ 'cursor': 'default' });
		        $('.delete-image, .delete-video', '.ui-sortable li').remove();
		        $('#videos .group-box:last-child').remove();
		        $('#standard-features + div').remove();
		        $('#optional-features + div').remove();
		    }

		    $('#listing-location').typeahead({

		        source: function (query, process) {

		            // Add load status
		            var $self = this.$element;
		            $self.css({
		                background: 'url(/media/1111/ajax-loader.gif) no-repeat 95% center'
		            });

		            // Remove load status on blur
		            $self.on('blur.load-status', function () { $(this).css('background', 'none'); });

		            // Data source
		            return $.getJSON(
						'/api?api=LocSearch&query=' + query,
						function (data) {
						    if (data.State == 1) {
						        $self.css('background', 'none');
						        var LocInfo = jQuery.parseJSON(data.Result);
						        return process(LocInfo);
						    }

						});
		        },

		        // Highlight typed in result
		        highlighter: function (item) {
		            var regex = new RegExp('(' + this.query + ')', 'gi');
		            return item.replace(regex, "<strong>$1</strong>");
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

		function PricingLoad()
		{
			PricingStructureChanged();
			
			$("#listing-has-price").click(function(e){
				PricingStructureChanged();
			});
			
			// Set selected value
			$('#listing-price-qualifier').val($('#listing-price-qualifier-orig').val());
			
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
			var IsRetailUser = false;
			if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
			if (IsRetailUser) return; // Not Applicable for retail user
			
			var CatID = $("#listing-category-id").val();
			if ($("#listing-has-price").prop('checked'))
			{
				ShowPricing(true);
				//Cars (60), Vintage (600), Hotrod (601), Motorbikes (67), truck and buss (80)
				if (CatID == '60' || CatID == '600' || CatID == '601' || CatID == '67' || CatID == '80')
				{
					PopulatePriceDropdown(AutoPriceDescOptions);	
				}
				else
				{
					PopulatePriceDropdown(GMPriceDescOptions);	
					
				}
			}
			else
			{
				ShowPricing(false);
				
				PopulatePriceDropdown(FreePriceDescOptions);
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

		function ShowPricing(show)
		{
			var IsRetailUser = false;
			if ($("#IsRetailUser").val() == 'true') IsRetailUser = true;
			
			if (IsRetailUser) return; // Not Applicable for retail user
			
			if (show)
			{
				$("#listing-pricing").show();
			}
			else
			{
				$("#listing-pricing").hide();
				
				$("#listing-driveaway-price").val('');
				$("#listing-sale-price").val('');
				$("#listing-unqualified-price").val('');
				$("#listing-price").val('');
			}
		}
		

		//=================================================================


		//Feed Destination List Setting
		//=================================================================
		
		//=================================================================