$(document).ready(function() {

    // Init feature editors
    updateFeatures();
	updateMotorFeatures();
	
    $('a.select-item-delete').live('click', function() {
        $(this).closest('li').addClass('to-be-remove');
		//$('i',this).removeClass('icon-remove').addClass('icon-undo');
		$(this).removeClass('btn-info').addClass('btn-danger');
		$(this).removeClass('select-item-delete').addClass('select-item-undo');
        updateFeatures();
		updateMotorFeatures();
        $('#update-features').val('true');
        $('form').not('.no-change-tracking').addClass('has-changes');
        return false;
    });
	
	$('a.select-item-undo').live('click', function() {
        $(this).closest('li').removeClass('to-be-remove');
		//$('i',this).removeClass('icon-undo').addClass('icon-remove');
		$(this).removeClass('btn-danger').addClass('btn-info');
		$(this).removeClass('select-item-undo').addClass('select-item-delete');
        updateFeatures();
		updateMotorFeatures();
        $('#update-features').val('true');
        $('form').not('.no-change-tracking').addClass('has-changes');
		return false;
	});
	
	
    $('#add-standard-feature').live('click', function() {
        if ($('#new-standard-feature').val()) {
            $('#standard-features').append('<li><a href="#" class="select-item-delete btn btn-small btn-info"><i class="icon-remove"></i></a> &nbsp; <span>' + $('#new-standard-feature').val() + '</span></li>')
        .animate({ scrollTop: $("#standard-features").prop("scrollHeight") }, 2000);
			if($('html').hasClass('lt-ie9')){
				replaceIcons();	
			}
            $('#new-standard-feature').val('').focus();
            updateFeatures();
            $('#update-features').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
            return false;
        }
    });

		
    $('#add-optional-feature').live('click', function() {
        if ($('#new-optional-feature').val()) {
            $('#optional-features').append('<li><a href="#" class="select-item-delete btn btn-small btn-info"><i class="icon-remove"></i></a> &nbsp; <span>' + $('#new-optional-feature').val() + '</span></li>')
        .animate({ scrollTop: $("#optional-features").prop("scrollHeight") }, 2000);
			if($('html').hasClass('lt-ie9')){
				replaceIcons();	
			}
			$('#new-optional-feature').val('').focus();
            updateFeatures();
            $('#update-features').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
            return false;
        }
    });
	
    $('#new-standard-feature').live('keypress', function(e) {
        if (e.keyCode == 13) {
            $('#add-standard-feature').click();
            return false;
        }
    });
	
    $('#new-optional-feature').live('keypress', function(e) {
        if (e.keyCode == 13) {
            $('#add-optional-feature').click();
            return false;
        }
    });
	
	//------------------------------------------------------------------------------------
	// Motorbikes
	//------------------------------------------------------------------------------------
	$('#add-motor-standard-feature').live('click', function() {
        if ($('#new-motor-standard-feature').val()) {
            $('#standard-motor-features').append('<li><a href="#" class="select-item-delete btn btn-small btn-info"><i class="icon-remove"></i></a> &nbsp; <span>' + $('#new-motor-standard-feature').val() + '</span></li>')
        .animate({ scrollTop: $("#standard-motor-features").prop("scrollHeight") }, 2000);
			if($('html').hasClass('lt-ie9')){
				replaceIcons();	
			}
            $('#new-motor-standard-feature').val('').focus();
            updateMotorFeatures();
            $('#update-features').val('true');
            $('form').not('.no-change-tracking').addClass('has-changes');
            return false;
        }
    });
	
	$('#new-motor-standard-feature').live('keypress', function(e) {
        if (e.keyCode == 13) {
            $('#add-standard-feature').click();
            return false;
        }
    });

});


function updateFeatures() {
    var standard = [];
	$('#standard-features li').not('.to-be-remove').each(function(index, element) {
		//standard[index] = $('span',element).html;
        standard[index] = $('span',element).last().text();
    });
    $('#listing-standard-features').val(standard.join('|'));
    var optional = [];
    $('#optional-features li').not('.to-be-remove').each(function(index, element) {
        //optional[index] = $('span',element).html();
		optional[index] = $('span',element).last().text();
    });
    $('#listing-optional-features').val(optional.join('|'));
	
	// Trigger lock
	var label = $('.FeaturesLock').parent().find('.lock-label').not('.locked');
	$(label).addClass('locked').find('input').attr('checked', 'checked');
}


function updateMotorFeatures() {
    var standard = [];
	$('#standard-motor-features li').not('.to-be-remove').each(function(index, element) {
        standard[index] = $('span',element).html();
    });
    $('#listing-motor-standard-features').val(standard.join('|'));
 
	// Trigger lock
	var label = $('.FeaturesLock').parent().find('.lock-label').not('.locked');
	$(label).addClass('locked').find('input').attr('checked', 'checked');
}


