$(document).ready(function() {

    // Init field lock checkboxes
    initLockLabels();
	
	$('input, select, textarea').live('change', function() {
		
		if ($('#listing-status').val() == 'Draft' || $('#listing-status').val() == 'Active')
		{
			
			$(this).parents('form').not('.no-change-tracking').addClass('has-changes');
			$('#update-listing').val('true');
			if ($(this).attr('type') != 'checkbox') {
				$(this).addClass('changed');
				
				//var label = $(this).parent().find('.lock-label').not('.locked');
				
				var label = '';
				if ($(this).parent().find('.lock-label').length != 0)
					label = $(this).parent().find('.lock-label').not('.locked');
				else
					label = $(this).parent().parent().find('.lock-label').not('.locked');
				
				if (label) {
					$(label).addClass('locked').find('input').attr('checked', 'checked');
				}
			}
		}
    });
	
	//$('#listing-thumbnails').on('contentChanged',function(){alert('UL content changed!!!');});
	
	
	
	// Special handle for price field
	// Change event not firing if user use mouse to browse away from prices fields.
	PriceLockEventCheck('listing-driveaway-price');
	PriceLockEventCheck('listing-sale-price');
	PriceLockEventCheck('listing-unqualified-price');
	PriceLockEventCheck('listing-price');
	PriceLockEventCheck('listing-was-price');
	

    $(window).bind('beforeunload', function(e) {
        var hasChanges = false;
        $('form.has-changes').each(function() {
            hasChanges = true;
        });
        if (hasChanges) {
            $('.changed').addClass('has-changed');
            return "Warning: You have some unsaved changes on this page. The changed fields have been highlighted in green.";
        }
    });

});

function PriceLockEventCheck(PriceCtrlName)
{
	$('#' + PriceCtrlName).live('blur', function() {
		if(($('#' + PriceCtrlName).val() == "" || $('#' + PriceCtrlName).val() == "0.00") && ($('#' + PriceCtrlName + '-orig').val() == "" || $('#' + PriceCtrlName + '-orig').val() == "0.00"))
		{
			return;
		}
		
		if($('#' + PriceCtrlName).val() != $('#' + PriceCtrlName + '-orig').val())
		{
			var label = $('#' + PriceCtrlName).parent().parent().find('.lock-label').not('.locked');
			if (label) {
                $(label).addClass('locked').find('input').attr('checked', 'checked');
            }
				
		}
	});
}


function initLockLabels() {
    $('input.lock-field').each(function() {
		$(this).attr('tabindex','-1');
        var id = $(this).attr('name');
        $(this).attr('id', id).wrap('<label class="lock-label" for="' + id + '" />');
    });
    $('.lock-label').click(function() {
        setupLockLabels();
    });
    setupLockLabels();
}

function setupLockLabels() {
    if ($('.lock-label input').length) {
        $('.lock-label').each(function() {
            $(this).removeClass('locked').attr('title', 'This field is unlocked, and may be overritten when data next syncs.');

        });
        $('.lock-label input:checked').each(function() {
            $(this).parent('label').addClass('locked').attr('title', 'This field is locked, so the original data sync source can no longer overwrite it.');
        });
    };
}

