$(function(){
	$('[data-password-meter]').each(function(){
		// Password strenght meter
		var r_limit = /^[\w\s!@#$%^&*]{8,20}$/;
		var r_upper = /(?=.*[A-Z])[\w\s!@#$%^&*]*/;
		var r_lower = /(?=.*[a-z])[\w\s!@#$%^&*]*/;
		var r_digit = /(?=.*[0-9])[\w\s!@#$%^&*]*/;
		var r_symbl = /(?=.*[!@#$%^&*])[\w\s!@#$%^&*]*/;
		
		var placement = 'right';
		
		if($(this).attr('data-password-meter-placement')){
			placement = $(this).attr('data-password-meter-placement');
		}
		

		$(this).popover({
			trigger: 'focus',
			placement: (Modernizr.mq('screen and (max-width:767px)')) ? 'top' : placement,
			html: true,
			title: 'Password strength',
			content: function(){
				return '<ul class="password-meter">' +
					   '  <li class="limit">8-20 characters</li>' +
					   '  <li class="upper">1 or more uppercase [A-Z]</li>' +
					   '  <li class="lower">1 or more lowercase [a-z]</li>' +
					   '  <li class="digit">1 or more number [0-9]</li>' +
					   '  <li class="symbol">1 or more symbol [!@#$%^&amp;*]</li>' +
					   '</ul>';
			}
		});
		
		$(this).on('focus.password-meter keyup.password-meter',function(){
			var v = $(this).val();
			if(r_limit.test(v)) {
				$('.password-meter .limit').addClass('success');
			} else {
				$('.password-meter .limit').removeClass('success');
			}
			if(r_upper.test(v)) {
				$('.password-meter .upper').addClass('success');
			} else {
				$('.password-meter .upper').removeClass('success');
			}
			if(r_lower.test(v)) {
				$('.password-meter .lower').addClass('success');
			} else {
				$('.password-meter .lower').removeClass('success');
			}
			if(r_digit.test(v)) {
				$('.password-meter .digit').addClass('success');
			} else {
				$('.password-meter .digit').removeClass('success');
			}
			if(r_symbl.test(v)) {
				$('.password-meter .symbol').addClass('success');
			} else {
				$('.password-meter .symbol').removeClass('success');
			}
			
		});
	
	});
});