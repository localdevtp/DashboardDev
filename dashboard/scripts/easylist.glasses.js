var GlassAPIURL = "/api?api=";

function LoadAllCarMakes()
{
    $.getJSON(GlassAPIURL + 'AllMakes', function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
        $("#easylist-Makes").html(items.join(''));
        RefreshControls();
    });
}

function MakeModelYearStyleChange(element, type, refreshControlName) {
    
    //---------------------------------------------------------------------
    // Initialise
    //---------------------------------------------------------------------
    var EmptyItems = [];
    EmptyItems.push('<option value="">Select an option</option>');
    
    if ($(element).val() == "") {   
        $(refreshControlName).html(EmptyItems.join(''));
        return;
    }
    
    
    switch(type)
    {
        case "Models":
            $("#easylist-Years").html(EmptyItems.join(''));
            $("#easylist-Styles").html(EmptyItems.join(''));
            $("#easylist-Transmission").html(EmptyItems.join(''));
            break;
        case "Years":
            $("#easylist-Styles").html(EmptyItems.join(''));
            $("#easylist-Transmission").html(EmptyItems.join(''));
            break;
        case "Styles":
            $("#easylist-Transmission").html(EmptyItems.join(''));
            break;
        case "Transmissions":
            break;
        default:
            //code to be executed if n is different from case 1 and 2
    }
    $("#easylist-Variant").html(EmptyItems.join(''));
    $('#group-standard-features').hide();
    $('#group-optional-features').hide();
    $('#easylist-standard-features').empty();
    $('#easylist-optional-features').empty();
    $('#easylist-specs').empty();
    
    //---------------------------------------------------------------------
    
    var Make = $("#easylist-Makes option:selected").val().trim();
    var Model = $("#easylist-Models option:selected").val().trim();
    var Year = $("#easylist-Years option:selected").val().trim();
    var Style = $("#easylist-Styles option:selected").val().trim();
    var Transmission = $("#easylist-Transmission option:selected").val().trim();
    
    var SearchParam = "";
    switch(type)
    {
        case "Models":
            SearchParam = '&make=' + Make;
            break;
        case "Years":
            SearchParam = '&make=' + Make + '&model=' + Model;
            break;
        case "Styles":
            SearchParam = '&make=' + Make + '&model=' + Model + '&year=' + Year;
            break;
        case "Transmissions":
            SearchParam = '&make=' + Make + '&model=' + Model + '&year=' + Year + '&style=' + Style;
            break;
        default:
            //code to be executed if n is different from case 1 and 2
    }
    
    $.getJSON(GlassAPIURL + 'Info&Type=' + type + SearchParam, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
        $(refreshControlName).html(items.join(''));
        RefreshControls();
    });
}

function TransmissionChange(element) {
    if ($(element).val() == "") return;
    
    var Make = $("#easylist-Makes option:selected").val().trim();
    var Model = $("#easylist-Models option:selected").val().trim();
    var Year = $("#easylist-Years option:selected").val().trim();
    var Style = $("#easylist-Styles option:selected").val().trim();
    var Transmission = $("#easylist-Transmission option:selected").val().trim();
    
    $.getJSON(GlassAPIURL + 'MatchingVehicle&make=' + Make + '&model=' + Model + '&year=' + Year + '&style=' + Style + '&Transmission=' + Transmission, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
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
        $("#easylist-Variant").html(items.join(''));
        RefreshControls();
    });
}

function VariantChange(element) {
    
    if ($(element).val() == "") {
        $('#group-standard-features').hide();
        $('#group-optional-features').hide();
        return;
    }
    
     $('#easylist-standard-features').empty();
     $('#easylist-optional-features').empty();
     $('#easylist-specs').empty();
     
     // Set the title field..
     var Make = $("#easylist-Makes option:selected").val().trim();
     var Model = $("#easylist-Models option:selected").val().trim();
     var Year = $("#easylist-Years option:selected").val().trim();
     var Style = $("#easylist-Styles option:selected").val().trim();
     
     var Variant = jQuery.parseJSON($(element).val()); 
     var GlassCode = Variant.GlassCode;
	 var Vehicle_Variant = Variant.Variant;
	 var Vehicle_Series = Variant.Series;
	 
	 //$('#listing-title').val(Year +' '+ Make +' '+ Model +' '+ Style.replace('D', ' Door'));
	 var Vehicle_Title = Year +' '+ Make +' '+ Model;
	 if (Vehicle_Variant) Vehicle_Title += ' ' + Vehicle_Variant;
	 if (Vehicle_Series) Vehicle_Title += ' ' + Vehicle_Series;
	 if (Style) Vehicle_Title += ' ' + Style;
	 
	 $('#listing-title').val(Vehicle_Title);
	 $('#listing-title').prop('readonly', true);
     
     //$('#listing-variant').val($("#easylist-Variant option:selected").text());
	$('#listing-variant').val(Vehicle_Variant);
	$('#listing-series').val(Vehicle_Series);
     
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
                     $('#group-standard-features').show();
                 }
                 else{
                     //$('#group-standard-features').hide();
                     $('#easylist-standard-features').html('<label>N/A</label>');
                     $('#group-standard-features').show();
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
                     //$('#group-optional-features').hide();
                     $('#easylist-optional-features').html('<label>N/A</label>');
                     $('#group-optional-features').show();
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
            }
            
            if(sfItems.length == 0 && ofItems.length == 0){
                //$("form.wizard").formwizard("next"); 
            }
        });
        RefreshControls();
        
    });
 }
 
 //----------------------------------------------------------------
 // Motorbikes
 //----------------------------------------------------------------
 
function LoadAllMotorMakes()
{
    $.getJSON(GlassAPIURL + 'AllMotorMakes', function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
        $("#easylist-Motor-Makes").html(items.join(''));
		
        RefreshMotorControls();
    });
}

function MotorMakeModelYearChange(element, type, refreshControlName) {
    
    //---------------------------------------------------------------------
    // Initialise
    //---------------------------------------------------------------------
    var EmptyItems = [];
    EmptyItems.push('<option value="">Select an option</option>');
    
    if ($(element).val() == "") {   
        $(refreshControlName).html(EmptyItems.join(''));
        return;
    }
    
    switch(type)
    {
        case "Models":
            $("#easylist-Motor-Years").html(EmptyItems.join(''));
            $("#easylist-Motor-Variant").html(EmptyItems.join(''));
            break;
        case "Years":
            $("#easylist-Motor-Variant").html(EmptyItems.join(''));
            break;
        default:
            //code to be executed if n is different from case 1 and 2
    }

    //---------------------------------------------------------------------
    
    var Make = $("#easylist-Motor-Makes option:selected").val().trim();
    var Model = $("#easylist-Motor-Models option:selected").val().trim();
    var Year = $("#easylist-Motor-Years option:selected").val().trim();
	
	$('#group-motor-features').hide();
    $('#easylist-motor-features').empty();

    var SearchParam = "";
    switch(type)
    {
        case "Models":
            SearchParam = '&make=' + Make;
            break;
        case "Years":
            SearchParam = '&make=' + Make + '&model=' + Model;
            break;
        default:
            //code to be executed if n is different from case 1 and 2
    }
    
    $.getJSON(GlassAPIURL + 'MotorInfo&type=' + type + SearchParam, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
        $(refreshControlName).html(items.join(''));
        RefreshMotorControls();
    });
}

 function MotorYearChange(element) {
    if ($(element).val() == "Select") return;

    var Make = $("#easylist-Motor-Makes option:selected").val().trim();
    var Model = $("#easylist-Motor-Models option:selected").val().trim();
    var Year = $("#easylist-Motor-Years option:selected").val().trim();
	
	$('#group-motor-features').hide();
    $('#easylist-motor-features').empty();
	
    $.getJSON(GlassAPIURL + 'MatchingMotor&make=' + Make + '&model=' + Model + '&year=' + Year, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {

            var mv = value;
            var JSONkey = JSON.stringify(mv);

            var Desc = "";

            if (mv.Styles != "") {
                if (Desc != "") Desc += ", ";
                Desc += "Style: " + mv.Styles;
            }
            
            if (mv.Variant != "") {
                if (Desc != "") Desc += ", ";
                Desc += "" + mv.Variant; 
            }

            if (mv.Transmission != "") {
                if (Desc != "") Desc += ", ";
                Desc += "" + mv.Transmission;
            }

            if (mv.Series != "") {
                if (Desc != "") Desc += ", ";
                Desc += "" + mv.Series;
            }
            
            if (mv.Engine != "") {
                if (Desc != "") Desc += ", ";
                Desc += "Engine: " + mv.Engine;
            }
            
            if (mv.Cylinder != "") {
                if (Desc != "") Desc += ", ";
                Desc += mv.Cylinder + " Cylinder";
            }

            items.push("<option value='" + JSONkey + "'>" + Desc + "</option>");
        });
        $('#easylist-Motor-Variant').html(items.join(''));
        RefreshMotorControls();
    });
}

function MotorVariantChange(element)
{
	//if ($(element).val() == 'Select') return;
    if ($(element).val() == "Select") {
        $('#group-motor-features').hide();
        return;
    }
     $('#group-motor-features').hide();
     $('#easylist-motor-features').empty();
	 
     $('#easylist-Motor-specs').empty();
	
    var mSpec = [];
    var Variant = jQuery.parseJSON($(element).val()); 
    
	var Make = $("#easylist-Motor-Makes option:selected").val().trim();
    var Model = $("#easylist-Motor-Models option:selected").val().trim();
    var Year = $("#easylist-Motor-Years option:selected").val().trim();
     
	var Vehicle_Variant = Variant.Variant;
	var Vehicle_Series = Variant.Series;
	var Vehicle_Styles = Variant.Styles;
	 
	var Vehicle_Title = Year +' '+ Make +' '+ Model;
	if (Vehicle_Variant) Vehicle_Title += ' ' + Vehicle_Variant;
	if (Vehicle_Series) Vehicle_Title += ' ' + Vehicle_Series;
	if (Vehicle_Styles) Vehicle_Title += ' ' + Vehicle_Styles;
	 
	$('#listing-title').val(Vehicle_Title);
	$('#listing-title').prop('readonly', true);
	 	
    // $('#listing-motor-variant').val($("#easylist-Motor-Variant option:selected").text());
	$('#listing-motor-variant').val(Vehicle_Variant);
	$('#listing-motor-series').val(Vehicle_Series);
		 
	var GlassCode = Variant.GlassCode;
	
	 $.getJSON(GlassAPIURL + 'MatchingMotorFeatures&GlassCode=' + GlassCode,
		function (data) {
			var sfItems = [];
			
			$.each(jQuery.parseJSON(data.Result), function (key, value) {
				 var vehicleFeature = value;

				 var StandardFeaturesCodeArray = vehicleFeature.StandardFeatures.split('|');
				 var StandardFeaturesNameArray = vehicleFeature.StandardFeaturesName.split('|');

				 if (StandardFeaturesCodeArray.Length != 0) {
					 for (var i = 0; i < StandardFeaturesCodeArray.length; i++) {
						 if (StandardFeaturesCodeArray[i] != "") {
							 sfItems.push('<label class="checkbox"><input type="checkbox" id="stdFeature-' + StandardFeaturesCodeArray[i].trim() + '" name="stdFeature-motor" value="'
								 + StandardFeaturesNameArray[i].trim() + '"/> '
									 + StandardFeaturesNameArray[i].trim() + '</label>')
						 }
					 }
					 if (sfItems.length > 0) {
						 $('#easylist-motor-features').html(sfItems.join(''));
						 $('#group-motor-features').show();
					 }
					 else{
						 //$('#group-standard-features').hide();
						 $('#easylist-motor-features').html('<label>N/A</label>');
						 $('#group-motor-features').show();
					 }
				 }
			});
		});
		
	mSpec.push('<input type="hidden" name="vehicle-Motor-BodyDesc" value="' + Variant.Styles + '"/>');
	mSpec.push('<input type="hidden" name="vehicle-Motor-BodyStyles" value="' + Variant.Styles + '"/>');
	mSpec.push('<input type="hidden" name="vehicle-Motor-Transmission-type" value="' + Variant.Transmission + '"/>');
	mSpec.push('<input type="hidden" name="vehicle-Motor-Transmission-desc" value="' + Variant.Transmission + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-NVIC" value="' + Variant.NVIC + '"/>');
	mSpec.push('<input type="hidden" name="vehicle-Motor-GlassCode" value="' + Variant.GlassCode + '"/>');
	mSpec.push('<input type="hidden" name="vehicle-Motor-Cylinder" value="' + Variant.Cylinder + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-Engine" value="' + Variant.Engine + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-EngineCC" value="' + Variant.EngineCC + '"/>');
    
    /*mSpec.push('<input type="hidden" name="vehicle-Motor-Styles" value="' + Variant.Styles + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-NVIC" value="' + Variant.NVIC + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-Transmission" value="' + Variant.Transmission + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-Engine" value="' + Variant.Engine + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-EngineCC" value="' + Variant.EngineCC + '"/>');
    mSpec.push('<input type="hidden" name="vehicle-Motor-Cylinder" value="' + Variant.Cylinder + '"/>');*/
    if (mSpec.length > 0) {
        $('#easylist-Motor-specs').append(mSpec.join(''));
    }
}

//----------------------------------------------------------------
 // Truck and Bus
 //----------------------------------------------------------------
  
function LoadAllCustomMakes(Type)
{
    $.getJSON(GlassAPIURL + 'AllCustomMakes&Type='+Type, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
		$("#easylist-custom-Makes").html(items.join(''));
		/*switch(Type)
		{
			case "TruckNBus":
				$("#easylist-custom-Makes").html(items.join(''));
				break;
			case "HotCustom":
				$("#easylist-custom-Makes").html(items.join(''));
				break;
			case "VintageClassic":
				$("#easylist-custom-Makes").html(items.join(''));
				break;
			default:
				//code to be executed if n is different from case 1 and 2
		}*/
        
        
    });
}


function LoadAllCustomModelChange(element, refreshControlName) {
    
    //---------------------------------------------------------------------
    // Initialise
    //---------------------------------------------------------------------
    var EmptyItems = [];
    EmptyItems.push('<option value="">Select an option</option>');
    
    if ($(element).val() == "") {   
        $(refreshControlName).html(EmptyItems.join(''));
        return;
    }
    
    //---------------------------------------------------------------------
    
	var Type = '';
	var CatID = $('#listing-category-id').val();
	var Make = "";
	var Model = "";
	switch(CatID)
	{
		case "80":
			Type = 'TruckNBus';
			Make = $("#easylist-custom-Makes option:selected").val().trim();
			Model = $("#easylist-custom-Models option:selected").val().trim();
			break;
		case "601":
			Type = 'HotCustom';
			Make = $("#easylist-custom-Makes option:selected").val().trim();
			Model = $("#easylist-custom-Models option:selected").val().trim();
			break;
		case "600":
			Type = 'VintageClassic';
			Make = $("#easylist-custom-Makes option:selected").val().trim();
			Model = $("#easylist-custom-Models option:selected").val().trim();
			break;
		default:
			//code to be executed if n is different from case 1 and 2
	}
    
	var SearchParam = 'Type='+ Type + '&Make=' + Make;
        
    $.getJSON(GlassAPIURL + 'CustomModels&' + SearchParam, function (data) {
        var items = [];
        items.push('<option value="">Select an option</option>');
        $.each(jQuery.parseJSON(data.Result), function (key, value) {
            items.push('<option value="' + value + '">' + value + '</option>');
        });
        $(refreshControlName).html(items.join(''));
        RefreshMotorControls();
    });
}