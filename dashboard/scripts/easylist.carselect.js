var GlassAPIURL = "/api?api=";
      
function renderCarLi(name, key, value){
	return '<li class="'+ name +'"><label class="radio" for="listing-'+ name +'-'+ key +'"><input type="radio" class="listing-'+ name +'" id="listing-'+ name +'-'+ key +'" name="listing-'+ name +'" value="'+ value +'"/>'+ value +'<span class="todo-actions"><i class="halflings-icon chevron-right"></i></span></label></li>';
}

function renderCarLiWithData(name, key, value, data){
	return '<li class="'+ name +'"><label class="radio" for="listing-'+ name +'-'+ key +'"><input type="radio" data-attribute="'+ data +'" class="listing-'+ name +'" id="listing-'+ name +'-'+ key +'" name="listing-'+ name +'" value="'+ value +'"/>'+ value +'<span class="todo-actions"><i class="halflings-icon chevron-right"></i></span></label></li>';
}

function getMake(){
	return $('input:radio[name=listing-make]:checked').val().trim();
}
function getModel(){
	return $('input:radio[name=listing-model]:checked').val().trim();
}
function getYear(){
	return $('input:radio[name=listing-year]:checked').val().trim();
}
function getBodyStyle(){
	return $('input:radio[name=listing-body-style]:checked').val().trim();
}
function getTransmission(){
	return $('input:radio[name=listing-transmission]:checked').val().trim();
}
function getGlassCode(){
	return $('input:radio[name=listing-variant]:checked').attr('data-attribute').trim();
}

        $(document).ajaxStart(function () {
            $("img#loading").show();
        });

        $(document).ajaxComplete(function () {
            $("img#loading").hide();
        });

        $(document).ready(function () {
			
			// Load all makes and render..
			$.getJSON(GlassAPIURL + 'AllMakes', function (data) {
                
				var items = [];	
                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push(renderCarLi('make', key, value));
				});
				$('#easylist-make-select').html(items.join(''));
				
				$('.listing-make').change(function(e) {
					MakeChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});				
            });

        });





        function MakeChange(element) {
			
			/*
            $(".Models").remove(); $(".lblModel").remove();
            $(".Years").remove(); $(".lblYear").remove();
            $(".Styles").remove(); $(".lblStyle").remove();
            $(".Transmissions").remove(); $(".lblTransmission").remove();
            $(".MachingVehicle").remove(); $(".lblMatchingVehicle").remove();
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();

            if ($(element).val() == "Select") return;

            var Make = $(element).val();
			*/
			
			//var Make = $(element).attr('value');
			
			$('#easylist-model-select').empty();
			
			var Make = getMake();
			
			//alert("make: "+ Make);
            
		   $.getJSON(GlassAPIURL + 'Info&Type=Models&make=' + Make, function (data) {
                var items = [];
				
				$.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push(renderCarLi('model', key, value));
				});
				
				$('#easylist-model-select').html(items.join(''));
				
				$('.listing-model').change(function(e){
					ModelChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});
										   
				/*
                items.push('<option value="Select">Select</option>');
                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push('<option value="' + value + '">' + value + '</option>');
                });

                $('<span class="lblModel">Model :</span>').appendTo($('#Model'));
                $('<select/>', {
                    'class': 'Models',
                    'onchange': 'ModelChange(this);',
                    html: items.join('')
                }).appendTo($('#Model'));*/
            });
        }

        function ModelChange(element) {
			/*
            $(".Years").remove(); $(".lblYear").remove();
            $(".Styles").remove(); $(".lblStyle").remove();
            $(".Transmissions").remove(); $(".lblTransmission").remove();
            $(".MachingVehicle").remove(); $(".lblMatchingVehicle").remove();
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();
			
            if ($(element).val() == "Select") return;

            var Make = $('.Makes').val();
            var Model = $(element).val();*/

			$('#easylist-year-select').empty();
			
			var Make = getMake();
			var Model = getModel();

			$.getJSON(GlassAPIURL + 'info&type=Years&make=' + Make + '&model=' + Model, function (data) {
				var items = [];
				$.each(jQuery.parseJSON(data.Result), function (key, value) {
                	items.push(renderCarLi('year', key, value));    
				});
				
				$('#easylist-year-select').html(items.join(''));
				
				$('.listing-year').change(function(e){
					YearChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});
				
				/*
                var items = [];
                items.push('<option value="Select">Select</option>');
                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push('<option value="' + value + '">' + value + '</option>');
                });

                $('<Label class="lblYear">Years :</Label>').appendTo($('#Year'));
                $('<select/>', {
                    'class': 'Years',
                    'onchange': 'YearChange(this);',
                    html: items.join('')
                }).appendTo($('#Year'));
				*/
            });
        }

        function YearChange(element) {
			
			/*
            $(".Styles").remove(); $(".lblStyle").remove();
            $(".Transmissions").remove(); $(".lblTransmission").remove();
            $(".MachingVehicle").remove(); $(".lblMatchingVehicle").remove();
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();

            if ($(element).val() == "Select") return;

            var Make = $('.Makes').val();
            var Model = $('.Models').val();
            var Year = $(element).val();
*/
			$('#easylist-body-style-select').empty();

			var Make = getMake();
			var Model = getModel();
			var Year = getYear();
			
            $.getJSON(GlassAPIURL + 'info&type=Styles&make=' + Make + '&model=' + Model + '&year=' + Year, function (data) {
				var items = [];
				$.each(jQuery.parseJSON(data.Result), function (key, value) {
                	items.push(renderCarLi('body-style', key, value));    
				});
				
				$('#easylist-body-style-select').html(items.join(''));
				
				$('.listing-body-style').change(function(e){
					StyleChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});
				
				/*
				var items = [];
                items.push('<option value="Select">Select</option>');
                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push('<option value="' + value + '">' + value + '</option>');
                });

                $('<Label class="lblStyle">Styles :</Label>').appendTo($('#Style'));
                $('<select/>', {
                    'class': 'Styles',
                    'onchange': 'StyleChange(this);',
                    html: items.join('')
                }).appendTo($('#Style'));
				*/
            });
        }

        function StyleChange(element) {
			
			/*
            $(".Transmissions").remove(); $(".lblTransmission").remove();
            $(".MachingVehicle").remove(); $(".lblMatchingVehicle").remove();
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();

            if ($(element).val() == "Select") return;

            var Make = $('.Makes').val();
            var Model = $('.Models').val();
            var Year = $('.Years').val();
            var Style = $(element).val();*/
			
			$('#easylist-transmission-select').empty();
			
			var Make = getMake();
			var Model = getModel();
			var Year = getYear();
			var Style = getBodyStyle();
            
			$.getJSON(GlassAPIURL + 'info&type=Transmissions&make=' + Make + '&model=' + Model + '&year=' + Year + '&style=' + Style, function (data) {
				var items = [];
				$.each(jQuery.parseJSON(data.Result), function (key, value) {
                	items.push(renderCarLi('transmission', key, value));    
				});
				
				$('#easylist-transmission-select').html(items.join(''));
				
				$('.listing-transmission').change(function(e){
					TransmissionChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});
				
				/*
				var items = [];
                items.push('<option value="Select">Select</option>');
                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    items.push('<option value="' + value + '">' + value + '</option>');
                });
                $('<Label class="lblTransmission">Transmissions :</Label>').appendTo($('#Transmission'));
                $('<select/>', {
                    'class': 'Transmissions',
                    'onchange': 'TransmissionChange(this);',
                    html: items.join('')
                }).appendTo($('#Transmission'));
				*/
            });
        }

        function TransmissionChange(element) {
			
			/*
            $(".MachingVehicle").remove(); $(".lblMatchingVehicle").remove();
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();

            if ($(element).val() == "Select") return;

            var Make = $('.Makes').val();
            var Model = $('.Models').val();
            var Year = $('.Years').val();
            var Style = $('.Styles').val();
            var Transmission = $(element).val();*/
			
			$('#easylist-variant-select').empty();
			
			var Make = getMake();
			var Model = getModel();
			var Year = getYear();
			var Style = getBodyStyle();
			var Transmission = getTransmission();

            $.getJSON(GlassAPIURL + 'MatchingVehicle&make=' + Make + '&model=' + Model + '&year=' + Year + '&style=' + Style + '&Transmission=' + Transmission, function (data) {
				
				var items = [];
				$.each(jQuery.parseJSON(data.Result), function (key, value) {
					
					var mv = value;
                    var JSONkey = JSON.stringify(mv);

                    var Desc = "";
                    if (mv.Variant != "") { Desc += mv.Variant; }
                    if (mv.Series != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Series;
                    }
                    if (mv.Cylinder != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Cylinder;
                    }
                    if (mv.Engine != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Engine;
                    }
					
                	items.push(renderCarLiWithData('variant', key, Desc, mv.GlassCode));    
				});
				
				$('#easylist-variant-select').html(items.join(''));
				
				$('.listing-variant').change(function(e){
					MachingVehicleChange($(this));
					e.preventDefault();
					$("form.wizard").formwizard("next"); 
				});
				
				/*
				
				var items = [];
                items.push('<option value="Select">Select</option>');
                $.each(jQuery.parseJSON(data.Result), function (key, value) {

                    var mv = value;
                    var JSONkey = JSON.stringify(mv);

                    var Desc = "";
                    if (mv.Variant != "") { Desc += mv.Variant; }
                    if (mv.Series != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Series;
                    }
                    if (mv.Cylinder != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Cylinder;
                    }
                    if (mv.Engine != "") {
                        if (Desc != "") Desc += ",";
                        Desc += mv.Engine;
                    }

                    items.push("<option value='" + JSONkey + "'>" + Desc + "</option>");
                });
                $('<Label class="lblMatchingVehicle">Maching Vehicle :</Label>').appendTo($('#MachingVehicle'));
                $('<select/>', {
                    'class': 'MachingVehicle',
                    'onchange': 'MachingVehicleChange(this);',
                    html: items.join('')
                }).appendTo($('#MachingVehicle'));
				*/
            });
        }

        function MachingVehicleChange(element) {
			/*
            $("#StandardFeaturesList").empty(); $(".lblStandardFeatures").remove();
            $("#OptionalFeaturesList").empty(); $(".lblOptionalFeatures").remove();
            $("#AdditionalInfoList").empty(); $(".lblAdditionalInfo").remove();

            if ($(element).val() == "Select") return;

            var MachingVehicle = jQuery.parseJSON($(element).val()); 
		
            var GlassCode = MachingVehicle.GlassCode;*/
			
			$('#easylist-standard-features').empty();
			$('#easylist-optional-features').empty();
            $('#group-car-spec').hide();
			$('#easylist-specs').empty();
			
			// Set the title field..
			
						
						var Make = getMake();
						var Model = getModel();
						var Year = getYear();
						var Style = getBodyStyle();
						
						$('#listing-title').val(Year +' '+ Make +' '+ Model +' '+ Style.replace('D', ' Door'));
							
			//alert('set title: '+ $('#listing-title').val());
					
			
			var GlassCode = getGlassCode();

			$.getJSON(GlassAPIURL + 'MatchingVehicleFeatures&GlassCode=' + GlassCode
            ,
            function (data) {
                var sfItems = [];
                var ofItems = [];
                var afItems = [];

                $.each(jQuery.parseJSON(data.Result), function (key, value) {
                    var vehicleFeature = value;

                    var StandardFeaturesCodeArray = vehicleFeature.StandardFeatures.split('|');
                    var StandardFeaturesNameArray = vehicleFeature.StandardFeaturesName.split('|');
                    var OptionalFeaturesCodeArray = vehicleFeature.OptionalFeatures.split('|')
                    var OptionalFeaturesNameArray = vehicleFeature.OptionalFeaturesName.split('|');

                    if (StandardFeaturesCodeArray.Length != 0) {
                        for (var i = 0; i < StandardFeaturesCodeArray.length; i++) {
                            /*if (StandardFeaturesCodeArray[i] != "") {
                                sfItems.push('<label class="checkbox"><input type="checkbox" id="standard-feature-' + StandardFeaturesCodeArray[i] + '" checked="checked" value="'
                                + StandardFeaturesNameArray[i] + '"/> '
                                + StandardFeaturesNameArray[i] + '</label>')
                            }*/
                            if (StandardFeaturesCodeArray[i] != "") {
                                sfItems.push('<label class="checkbox"><input type="checkbox" id="stdFeature-' + StandardFeaturesCodeArray[i].trim() + '" name="stdFeature" checked="checked" value="'
                                + StandardFeaturesNameArray[i].trim() + '"/> '
                                + StandardFeaturesNameArray[i].trim() + '</label>')
                            }

                        }
                        if (sfItems.length > 0) {
                            
                            $('#easylist-standard-features').html(sfItems.join(''));
                        }
						else{
						}
                    }
                    if (OptionalFeaturesCodeArray.Length != 0) {
                        for (var i = 0; i < OptionalFeaturesCodeArray.length; i++) {
                            if (OptionalFeaturesCodeArray[i] != "") {
                                ofItems.push('<label class="checkbox"><input type="checkbox" id="optFeature-' + OptionalFeaturesCodeArray[i].trim() + '" name="optFeature" value="'
                                + OptionalFeaturesNameArray[i].trim() + '"/> '
                                + OptionalFeaturesNameArray[i].trim() + '</label>')
                            }
                        }
                        if (ofItems.length > 0) {
                            //$('<Label class="lblOptionalFeatures">Optional Features :</Label>').appendTo($('#OptionalFeatures'));
                            $('#easylist-optional-features').html(ofItems.join(''));
							$('#group-optional-features').show();
                        }
						else{
							$('#group-optional-features').hide();
						}
                    }


                    //------------------------------------------------------------------------------------------------
                    // Additional Info
                    //------------------------------------------------------------------------------------------------
                    afItems.push('<input type="hidden" name="vehicle-price-1" value="' + vehicleFeature.NewPrice + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-price-2" value="' + vehicleFeature.BAV + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-nvic" value="' + vehicleFeature.NVIC + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-vin" value="' + vehicleFeature.VinNumber + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-doors" value="' + vehicleFeature.NoOfDoors + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-seats" value="' + vehicleFeature.Seats + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-drive-type" value="' + vehicleFeature.DriveType + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-transmission-type" value="' + vehicleFeature.TT + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-transmission-info" value="' + vehicleFeature.Transmission + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-engine-type" value="' + vehicleFeature.Engine + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-engine-cc" value="' + vehicleFeature.CC + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-engine-size" value="' + vehicleFeature.Size + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-engine-cylinders" value="' + vehicleFeature.Cylinder + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-fuel-type" value="' + vehicleFeature.FuelType + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-fuel-highway" value="' + vehicleFeature.FuelConsumptionHWay + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-fuel-city" value="' + vehicleFeature.FuelConsumptionCity + '"/>');
                    afItems.push('<input type="hidden" name="vehicle-valve-gear" value="' + vehicleFeature.ValveGear + '"/>');


                    if (afItems.length > 0) {
                        //$('<Label class="lblAdditionalInfo">Additional Info :</Label>').appendTo($('#AdditionalInfo'));
                        $('#easylist-specs').append(afItems.join(''));
                        $('#group-car-spec').show();
                    }
					
					
					
					if(sfItems.length == 0 && ofItems.length == 0){
						$("form.wizard").formwizard("next"); 
					}
                });
            });
        }