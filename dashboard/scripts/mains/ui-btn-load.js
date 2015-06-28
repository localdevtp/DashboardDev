$(function(){
	// LeeMeng 20131029. Disable due to its block form submit event for 2nd times onwards if form is invalid before
	
	/*var submitClick = false;

	$('.btn').on('click', function(e){
		var $self = $(this);
		var $pform = $(this).closest('form');
		
		// if this a submit button?
		if($self.attr('type') == 'submit'){
			// proceed only if form is valid
			try {
				if($pform.valid()) {
					$('.btn-load', $pform).removeClass('btn-inverse btn-load');
					$self.not('.ignore-load').addClass('btn-inverse btn-load');
					if(!$self.hasClass('ignore-block')) { $self.on('click.btn-block', ignore); }
					else { $self.off('click.btn-block'); }
					submitClick = true;
				}
			} catch(e) {
					$('.btn-load', $pform).removeClass('btn-inverse btn-load');
					$self.not('.ignore-load').addClass('btn-inverse btn-load');
					if(!$self.hasClass('ignore-block')) { $self.on('click.btn-block', ignore); }
					else { $self.off('click.btn-block'); }
					submitClick = true;
			}
		}
	});
	
	$('form').on('submit.btn-load',function(){
		if(!submitClick){
			var $bs = $(this).has('.btn[type="submit"]');
			if($bs){
				try {
					if($bs.valid()) {
						$('.btn[type="submit"]',$bs).not('.ignore-load').last().addClass('btn-inverse btn-load');
					}
				} catch(e) {
					$('.btn[type="submit"]',$bs).not('.ignore-load').last().addClass('btn-inverse btn-load');
				}
			}
		}
	});*/
});

function ignore(e){
	e.stopImmediatePropagation();
	e.preventDefault();
}
function resetbtnload(e) {
	if($(e).hasClass('btn-load')){
		$(e).removeClass('btn-inverse btn-load');
		$(e).off('click.btn-block');
	}
	return true;
}

$.fn.resetbtnload = function(){
    return this.each(function () {
      resetbtnload(this);
    })
}